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
  // Filled in the background by Gemini shortly after the workout finishes
  // (fire-and-forget, never blocks finishing) — null for older sessions and
  // whenever the call fails or no Gemini key is set.
  TextColumn get aiSummary => text().nullable()();
}
