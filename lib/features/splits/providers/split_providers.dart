import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/app_database.dart';
import '../../../database/queries/split_queries.dart';
import '../../../providers/database_provider.dart';

final splitListProvider = StreamProvider<List<Split>>((ref) {
  return ref.watch(appDatabaseProvider).watchAllSplits();
});

final splitByIdProvider = StreamProvider.family<Split?, int>((ref, splitId) {
  return ref.watch(appDatabaseProvider).watchSplitById(splitId);
});

final splitDayByIdProvider = StreamProvider.family<SplitDay?, int>((ref, splitDayId) {
  return ref.watch(appDatabaseProvider).watchSplitDayById(splitDayId);
});

final splitDaysProvider = StreamProvider.family<List<SplitDay>, int>((ref, splitId) {
  return ref.watch(appDatabaseProvider).watchSplitDays(splitId);
});

final splitDayExercisesProvider =
    StreamProvider.family<List<SplitDayExerciseWithExercise>, int>((ref, splitDayId) {
  return ref.watch(appDatabaseProvider).watchSplitDayExercises(splitDayId);
});

class SplitController {
  final AppDatabase _db;
  SplitController(this._db);

  Future<int> createSplit({required String name, String? description}) {
    return _db.insertSplit(name: name, description: description);
  }

  Future<void> deleteSplit(int splitId) => _db.deleteSplit(splitId);

  Future<int> addDay({required int splitId, required String name}) {
    return _db.insertSplitDay(splitId: splitId, name: name);
  }

  Future<void> deleteDay(int splitDayId) => _db.deleteSplitDay(splitDayId);

  Future<int> addExerciseToDay({
    required int splitDayId,
    required int exerciseId,
    required int targetSets,
    int? targetRepsLow,
    int? targetRepsHigh,
  }) {
    return _db.insertSplitDayExercise(
      splitDayId: splitDayId,
      exerciseId: exerciseId,
      targetSets: targetSets,
      targetRepsLow: targetRepsLow,
      targetRepsHigh: targetRepsHigh,
    );
  }

  Future<void> removeExerciseFromDay(int splitDayExerciseId) =>
      _db.deleteSplitDayExercise(splitDayExerciseId);
}

final splitControllerProvider = Provider<SplitController>((ref) {
  return SplitController(ref.watch(appDatabaseProvider));
});
