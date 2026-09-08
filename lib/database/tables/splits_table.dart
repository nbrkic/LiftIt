import 'package:drift/drift.dart';
import 'exercises_table.dart';

class Splits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().nullable()();
}

@TableIndex(name: 'split_day_split_idx', columns: {#splitId})
class SplitDays extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get splitId =>
      integer().references(Splits, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get dayOrder => integer()();
}

@TableIndex(name: 'split_day_exercise_day_idx', columns: {#splitDayId})
class SplitDayExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get splitDayId =>
      integer().references(SplitDays, #id, onDelete: KeyAction.cascade)();
  IntColumn get exerciseId => integer().references(Exercises, #id)();
  IntColumn get targetSets => integer()();
  IntColumn get targetRepsLow => integer().nullable()();
  IntColumn get targetRepsHigh => integer().nullable()();
  IntColumn get order => integer()();
}
