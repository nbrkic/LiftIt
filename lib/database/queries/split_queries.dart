import 'package:drift/drift.dart';
import '../app_database.dart';

class SplitDayExerciseWithExercise {
  final SplitDayExercise planned;
  final Exercise exercise;
  SplitDayExerciseWithExercise({required this.planned, required this.exercise});
}

extension SplitQueries on AppDatabase {
  Stream<List<Split>> watchAllSplits() {
    return (select(splits)..orderBy([(s) => OrderingTerm.asc(s.name)])).watch();
  }

  Future<int> insertSplit({required String name, String? description}) {
    return into(splits).insert(
      SplitsCompanion.insert(name: name, description: Value(description)),
    );
  }

  Future<void> deleteSplit(int splitId) {
    return (delete(splits)..where((s) => s.id.equals(splitId))).go();
  }

  Stream<Split?> watchSplitById(int splitId) {
    return (select(splits)..where((s) => s.id.equals(splitId))).watchSingleOrNull();
  }

  Stream<SplitDay?> watchSplitDayById(int splitDayId) {
    return (select(splitDays)..where((d) => d.id.equals(splitDayId))).watchSingleOrNull();
  }

  Stream<List<SplitDay>> watchSplitDays(int splitId) {
    return (select(splitDays)
          ..where((d) => d.splitId.equals(splitId))
          ..orderBy([(d) => OrderingTerm.asc(d.dayOrder)]))
        .watch();
  }

  Future<int> insertSplitDay({required int splitId, required String name}) async {
    final existing = await (select(splitDays)..where((d) => d.splitId.equals(splitId))).get();
    return into(splitDays).insert(
      SplitDaysCompanion.insert(splitId: splitId, name: name, dayOrder: existing.length),
    );
  }

  Future<void> deleteSplitDay(int splitDayId) {
    return (delete(splitDays)..where((d) => d.id.equals(splitDayId))).go();
  }

  Stream<List<SplitDayExerciseWithExercise>> watchSplitDayExercises(int splitDayId) {
    final query = select(splitDayExercises).join([
      innerJoin(exercises, exercises.id.equalsExp(splitDayExercises.exerciseId)),
    ])
      ..where(splitDayExercises.splitDayId.equals(splitDayId))
      ..orderBy([OrderingTerm.asc(splitDayExercises.order)]);
    return query.watch().map(
          (rows) => rows
              .map((row) => SplitDayExerciseWithExercise(
                    planned: row.readTable(splitDayExercises),
                    exercise: row.readTable(exercises),
                  ))
              .toList(),
        );
  }

  Future<List<SplitDayExerciseWithExercise>> getSplitDayExercisesOnce(int splitDayId) {
    return watchSplitDayExercises(splitDayId).first;
  }

  Future<int> insertSplitDayExercise({
    required int splitDayId,
    required int exerciseId,
    required int targetSets,
    int? targetRepsLow,
    int? targetRepsHigh,
  }) async {
    final existing = await (select(splitDayExercises)
          ..where((e) => e.splitDayId.equals(splitDayId)))
        .get();
    return into(splitDayExercises).insert(
      SplitDayExercisesCompanion.insert(
        splitDayId: splitDayId,
        exerciseId: exerciseId,
        targetSets: targetSets,
        targetRepsLow: Value(targetRepsLow),
        targetRepsHigh: Value(targetRepsHigh),
        order: existing.length,
      ),
    );
  }

  Future<void> deleteSplitDayExercise(int splitDayExerciseId) {
    return (delete(splitDayExercises)..where((e) => e.id.equals(splitDayExerciseId))).go();
  }
}
