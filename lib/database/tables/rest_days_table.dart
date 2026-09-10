import 'package:drift/drift.dart';

// One row per calendar day the user explicitly marked as a planned rest
// day — date is day-truncated (midnight local time) and unique, so marking
// the same day twice is a no-op. Used by the daily streak calculator: a day
// counts toward the streak if it has either a finished workout or a row here.
@TableIndex(name: 'rest_day_date_idx', columns: {#date})
class RestDays extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime().unique()();
}
