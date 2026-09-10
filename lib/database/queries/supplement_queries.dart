import 'package:drift/drift.dart';
import '../app_database.dart';

extension SupplementQueries on AppDatabase {
  Stream<List<Supplement>> watchSupplements() {
    return (select(supplements)..orderBy([(s) => OrderingTerm.asc(s.createdAt)])).watch();
  }

  Future<int> insertSupplement({required String name, required String dosageLabel}) {
    return into(supplements).insert(SupplementsCompanion.insert(
      name: name,
      dosageLabel: dosageLabel,
      createdAt: DateTime.now(),
    ));
  }

  Future<void> deleteSupplement(int id) =>
      (delete(supplements)..where((s) => s.id.equals(id))).go();

  Stream<List<SupplementLog>> watchSupplementLogsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return (select(supplementLogs)..where((l) => l.takenOn.equals(normalizedDay))).watch();
  }

  Future<void> setSupplementTaken({
    required int supplementId,
    required DateTime day,
    required bool taken,
  }) async {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    if (taken) {
      final existing = await (select(supplementLogs)
            ..where((l) => l.supplementId.equals(supplementId) & l.takenOn.equals(normalizedDay)))
          .getSingleOrNull();
      if (existing == null) {
        await into(supplementLogs).insert(SupplementLogsCompanion.insert(
          supplementId: supplementId,
          takenOn: normalizedDay,
        ));
      }
    } else {
      await (delete(supplementLogs)
            ..where((l) => l.supplementId.equals(supplementId) & l.takenOn.equals(normalizedDay)))
          .go();
    }
  }
}
