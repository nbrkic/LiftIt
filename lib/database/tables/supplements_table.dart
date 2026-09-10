import 'package:drift/drift.dart';

// A supplement the user wants to take regularly (e.g. "Creatine" / "5g"),
// separate from SupplementLogs, which records whether it was actually taken
// on a given day.
class Supplements extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get dosageLabel => text()(); // free-text amount+unit, e.g. "5g"
  DateTimeColumn get createdAt => dateTime()();
}

// One row = one supplement checked off on one day. Deleting the row (rather
// than storing a boolean) means toggling the checkbox off just removes the
// row instead of needing an update — same idea as WaterLogs, but a presence
// check instead of a sum.
@TableIndex(name: 'supplement_log_taken_on_idx', columns: {#supplementId, #takenOn})
class SupplementLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get supplementId =>
      integer().references(Supplements, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get takenOn => dateTime()(); // normalized to the day (00:00)
}
