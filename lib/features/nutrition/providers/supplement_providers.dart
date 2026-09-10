import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/date_utils.dart';
import '../../../database/app_database.dart';
import '../../../database/queries/supplement_queries.dart';
import '../../../providers/database_provider.dart';

final supplementsProvider = StreamProvider<List<Supplement>>((ref) {
  return ref.watch(appDatabaseProvider).watchSupplements();
});

final supplementLogsForDayProvider = StreamProvider.family<List<SupplementLog>, DateTime>((ref, day) {
  return ref.watch(appDatabaseProvider).watchSupplementLogsForDay(dayOf(day));
});

final takenSupplementIdsProvider = Provider.family<Set<int>, DateTime>((ref, day) {
  final logs = ref.watch(supplementLogsForDayProvider(day)).value ?? const [];
  return logs.map((l) => l.supplementId).toSet();
});

class SupplementController {
  final AppDatabase _db;
  SupplementController(this._db);

  Future<int> addSupplement({required String name, required String dosageLabel}) {
    return _db.insertSupplement(name: name, dosageLabel: dosageLabel);
  }

  Future<void> deleteSupplement(int id) => _db.deleteSupplement(id);

  Future<void> setTaken({required int supplementId, required DateTime day, required bool taken}) {
    return _db.setSupplementTaken(supplementId: supplementId, day: day, taken: taken);
  }
}

final supplementControllerProvider = Provider<SupplementController>((ref) {
  return SupplementController(ref.watch(appDatabaseProvider));
});
