import 'package:drift/drift.dart';
import 'splits_table.dart';

class WorkoutSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();

  // setNull, not cascade: deleting a split/day later must never destroy
  // training history.
  IntColumn get splitDayId =>
      integer().nullable().references(SplitDays, #id, onDelete: KeyAction.setNull)();
  TextColumn get notes => text().nullable()();
}
