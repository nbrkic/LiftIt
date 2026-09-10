import 'package:drift/drift.dart';
import '../app_database.dart';
import '../enums.dart';

extension FoodLogQueries on AppDatabase {
  Stream<List<FoodLogEntry>> watchFoodLogForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return (select(foodLogEntries)
          ..where((f) => f.loggedAt.isBiggerOrEqualValue(start) & f.loggedAt.isSmallerThanValue(end))
          ..orderBy([(f) => OrderingTerm.desc(f.loggedAt)]))
        .watch();
  }

  Future<int> insertFoodLogEntry({
    required String name,
    String? brand,
    required double calories,
    required double proteinG,
    required double carbsG,
    required double fatG,
    required String quantityLabel,
    required FoodLogSource source,
    String? sourceId,
    required DateTime loggedAt,
  }) {
    return into(foodLogEntries).insert(FoodLogEntriesCompanion.insert(
      name: name,
      brand: Value(brand),
      calories: calories,
      proteinG: proteinG,
      carbsG: carbsG,
      fatG: fatG,
      quantityLabel: quantityLabel,
      source: source,
      sourceId: Value(sourceId),
      loggedAt: loggedAt,
    ));
  }

  Future<void> deleteFoodLogEntry(int id) =>
      (delete(foodLogEntries)..where((f) => f.id.equals(id))).go();
}
