import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/app_database.dart';
import '../../../database/queries/saved_foods_queries.dart';
import '../../../providers/database_provider.dart';

final savedFoodsProvider = StreamProvider<List<SavedFood>>((ref) {
  return ref.watch(appDatabaseProvider).watchSavedFoods();
});

class SavedFoodsController {
  final AppDatabase _db;
  SavedFoodsController(this._db);

  Future<int> saveFood({
    required String name,
    String? brand,
    required String quantityLabel,
    required double calories,
    required double proteinG,
    required double carbsG,
    required double fatG,
    required bool isPer100g,
  }) {
    return _db.insertSavedFood(
      name: name,
      brand: brand,
      quantityLabel: quantityLabel,
      calories: calories,
      proteinG: proteinG,
      carbsG: carbsG,
      fatG: fatG,
      isPer100g: isPer100g,
    );
  }

  Future<void> deleteFood(int id) => _db.deleteSavedFood(id);
}

final savedFoodsControllerProvider = Provider<SavedFoodsController>((ref) {
  return SavedFoodsController(ref.watch(appDatabaseProvider));
});
