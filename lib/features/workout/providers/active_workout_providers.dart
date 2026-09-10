import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/app_database.dart';
import '../../../database/queries/workout_queries.dart';
import '../../../providers/database_provider.dart';
import '../../nutrition/services/gemini_service.dart';
import '../services/workout_summary_prompt.dart';

final activeSessionProvider = StreamProvider<WorkoutSession?>((ref) {
  return ref.watch(appDatabaseProvider).watchActiveSession();
});

final activeSessionSetsProvider = StreamProvider.autoDispose<List<WorkoutSetWithExercise>>((ref) {
  final session = ref.watch(activeSessionProvider).value;
  if (session == null) return const Stream.empty();
  return ref.watch(appDatabaseProvider).watchSetsForSession(session.id);
});

class ActiveWorkoutController {
  final AppDatabase _db;
  ActiveWorkoutController(this._db);

  Future<int> startWorkout({int? splitDayId}) =>
      _db.startWorkoutSession(splitDayId: splitDayId);

  Future<int> logSet({
    required int sessionId,
    required int exerciseId,
    required int setNumber,
    required double weight,
    required int reps,
    double? rpe,
    bool isWarmup = false,
    String? notes,
  }) {
    return _db.logSet(
      sessionId: sessionId,
      exerciseId: exerciseId,
      setNumber: setNumber,
      weight: weight,
      reps: reps,
      rpe: rpe,
      isWarmup: isWarmup,
      notes: notes,
    );
  }

  Future<void> deleteSet(int setId) => _db.deleteSet(setId);

  Future<void> finishWorkout(int sessionId) => _db.finishWorkoutSession(sessionId);

  // Fire-and-forget from the caller's side by design: called without
  // `await` right after finishing a workout, so it never holds up the
  // completion UI. Any failure (no key, offline, Gemini error) is swallowed
  // — the session just ends up with no summary, same as before this
  // feature existed.
  Future<void> generateAiSummary({
    required int sessionId,
    required String apiKey,
    required String languageName,
    required bool hasPr,
  }) async {
    try {
      final session = await _db.watchSessionById(sessionId).first;
      if (session?.endedAt == null) return;
      final sets = await _db.getSetsForSession(sessionId);
      if (sets.isEmpty) return;

      final volume =
          sets.where((s) => !s.set.isWarmup).fold(0.0, (sum, s) => sum + s.set.weight * s.set.reps);
      final duration = session!.endedAt!.difference(session.startedAt);

      final previous = await _db.getPreviousComparableSession(
        splitDayId: session.splitDayId,
        beforeSessionId: sessionId,
        beforeStartedAt: session.startedAt,
      );
      List<WorkoutSetWithExercise>? previousSets;
      double? previousVolume;
      Duration? previousDuration;
      if (previous != null) {
        previousSets = await _db.getSetsForSession(previous.id);
        previousVolume = previousSets
            .where((s) => !s.set.isWarmup)
            .fold<double>(0.0, (sum, s) => sum + s.set.weight * s.set.reps);
        previousDuration = previous.endedAt!.difference(previous.startedAt);
      }

      final prompt = buildWorkoutSummaryPrompt(
        languageName: languageName,
        duration: duration,
        volume: volume,
        sets: sets,
        hasPr: hasPr,
        previousDuration: previousDuration,
        previousVolume: previousVolume,
        previousSets: previousSets,
      );
      final summary = await GeminiService().generateText(prompt, apiKey);
      await _db.setSessionAiSummary(sessionId, summary);
    } catch (e) {
      debugPrint('[WorkoutSummary] failed to generate summary for session $sessionId: $e');
    }
  }
}

final activeWorkoutControllerProvider = Provider<ActiveWorkoutController>((ref) {
  return ActiveWorkoutController(ref.watch(appDatabaseProvider));
});
