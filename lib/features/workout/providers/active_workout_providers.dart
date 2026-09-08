import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/app_database.dart';
import '../../../database/queries/workout_queries.dart';
import '../../../providers/database_provider.dart';

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
}

final activeWorkoutControllerProvider = Provider<ActiveWorkoutController>((ref) {
  return ActiveWorkoutController(ref.watch(appDatabaseProvider));
});
