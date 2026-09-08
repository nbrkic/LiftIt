import 'package:drift/drift.dart';

@TableIndex(name: 'bodyweight_log_logged_at_idx', columns: {#loggedAt})
class BodyweightLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get weightKg => real()(); // kilograms — canonical unit, same as WorkoutSets.weight
  DateTimeColumn get loggedAt => dateTime()();
  TextColumn get notes => text().nullable()();
}
