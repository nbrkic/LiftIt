import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/app_database.dart';
import '../../../database/queries/workout_queries.dart';
import '../../../providers/database_provider.dart';

final pastSessionsProvider = StreamProvider<List<WorkoutSession>>((ref) {
  return ref.watch(appDatabaseProvider).watchPastSessions();
});

final sessionDetailProvider =
    StreamProvider.family.autoDispose<List<WorkoutSetWithExercise>, int>((ref, sessionId) {
  return ref.watch(appDatabaseProvider).watchSetsForSession(sessionId);
});

final sessionByIdProvider =
    StreamProvider.family.autoDispose<WorkoutSession?, int>((ref, sessionId) {
  return ref.watch(appDatabaseProvider).watchSessionById(sessionId);
});

class HistoryController {
  final AppDatabase _db;
  HistoryController(this._db);

  Future<void> deleteSession(int sessionId) => _db.deleteSession(sessionId);
}

final historyControllerProvider = Provider<HistoryController>((ref) {
  return HistoryController(ref.watch(appDatabaseProvider));
});
