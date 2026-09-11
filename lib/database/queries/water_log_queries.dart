import 'package:drift/drift.dart';
import '../app_database.dart';

extension WaterLogQueries on AppDatabase {
  Stream<List<WaterLog>> watchWaterLogForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return (select(waterLogs)
          ..where((w) => w.loggedAt.isBiggerOrEqualValue(start) & w.loggedAt.isSmallerThanValue(end))
          ..orderBy([(w) => OrderingTerm.desc(w.loggedAt)]))
        .watch();
  }

  Future<int> insertWaterLog(int amountMl, {DateTime? loggedAt}) {
    return into(waterLogs).insert(WaterLogsCompanion.insert(
      amountMl: amountMl,
      loggedAt: loggedAt ?? DateTime.now(),
    ));
  }

  Future<void> deleteWaterLog(int id) =>
      (delete(waterLogs)..where((w) => w.id.equals(id))).go();
}
