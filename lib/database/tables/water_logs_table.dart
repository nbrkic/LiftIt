import 'package:drift/drift.dart';

// Each quick-add tap is its own row (like FoodLogEntries), summed per day —
// this makes "undo the last tap" trivial and keeps the same day-ranged
// query shape already used for food.
@TableIndex(name: 'water_log_logged_at_idx', columns: {#loggedAt})
class WaterLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get amountMl => integer()();
  DateTimeColumn get loggedAt => dateTime()();
}
