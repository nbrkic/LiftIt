import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/date_utils.dart';
import '../../../database/app_database.dart';
import '../../../database/queries/water_log_queries.dart';
import '../../../providers/database_provider.dart';

final waterLogForDayProvider = StreamProvider.family<List<WaterLog>, DateTime>((ref, day) {
  return ref.watch(appDatabaseProvider).watchWaterLogForDay(dayOf(day));
});

final dailyWaterTotalMlProvider = Provider.family<int, DateTime>((ref, day) {
  final entries = ref.watch(waterLogForDayProvider(day)).value ?? const [];
  return entries.fold(0, (sum, e) => sum + e.amountMl);
});

class WaterLogController {
  final AppDatabase _db;
  WaterLogController(this._db);

  Future<int> addWater(int amountMl) => _db.insertWaterLog(amountMl);

  Future<void> deleteEntry(int id) => _db.deleteWaterLog(id);
}

final waterLogControllerProvider = Provider<WaterLogController>((ref) {
  return WaterLogController(ref.watch(appDatabaseProvider));
});
