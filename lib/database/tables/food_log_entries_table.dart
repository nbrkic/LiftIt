import 'package:drift/drift.dart';
import '../enums.dart';

// Denormalized on purpose — every value here is resolved and stored at log
// time (like WorkoutSets/BodyweightLogs), never a live reference to an
// external barcode/fdcId. A logged entry must keep working even if the
// upstream product changes or the API/key becomes unavailable later.
@TableIndex(name: 'food_log_logged_at_idx', columns: {#loggedAt})
class FoodLogEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get brand => text().nullable()();
  RealColumn get calories => real()(); // kcal, already scaled to the logged quantity
  RealColumn get proteinG => real()();
  RealColumn get carbsG => real()();
  RealColumn get fatG => real()();
  TextColumn get quantityLabel => text()(); // human-readable, e.g. "150 g"
  TextColumn get source => textEnum<FoodLogSource>()();
  TextColumn get sourceId => text().nullable()(); // barcode/fdcId — metadata only, never re-fetched
  DateTimeColumn get loggedAt => dateTime()();
}
