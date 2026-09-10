import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/date_utils.dart';
import '../../../database/app_database.dart';
import '../../../database/enums.dart';
import '../../../database/queries/food_log_queries.dart';
import '../../../providers/database_provider.dart';
import '../services/food_search_result.dart';

final foodLogForDayProvider = StreamProvider.family<List<FoodLogEntry>, DateTime>((ref, day) {
  return ref.watch(appDatabaseProvider).watchFoodLogForDay(dayOf(day));
});

final dailyNutritionTotalsProvider = Provider.family<NutritionTotals, DateTime>((ref, day) {
  final entries = ref.watch(foodLogForDayProvider(day)).value ?? const [];
  return NutritionTotals.fromEntries(entries);
});

class FoodLogController {
  final AppDatabase _db;
  FoodLogController(this._db);

  Future<int> logEntry({
    required String name,
    String? brand,
    required double calories,
    required double proteinG,
    required double carbsG,
    required double fatG,
    required String quantityLabel,
    required FoodLogSource source,
    String? sourceId,
    DateTime? loggedAt,
  }) {
    return _db.insertFoodLogEntry(
      name: name,
      brand: brand,
      calories: calories,
      proteinG: proteinG,
      carbsG: carbsG,
      fatG: fatG,
      quantityLabel: quantityLabel,
      source: source,
      sourceId: sourceId,
      loggedAt: loggedAt ?? DateTime.now(),
    );
  }

  Future<void> deleteEntry(int id) => _db.deleteFoodLogEntry(id);
}

final foodLogControllerProvider = Provider<FoodLogController>((ref) {
  return FoodLogController(ref.watch(appDatabaseProvider));
});
