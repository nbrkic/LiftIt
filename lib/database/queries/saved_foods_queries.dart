import 'package:drift/drift.dart';
import '../app_database.dart';

extension SavedFoodsQueries on AppDatabase {
  Stream<List<SavedFood>> watchSavedFoods() {
    return (select(savedFoods)..orderBy([(f) => OrderingTerm.desc(f.savedAt)])).watch();
  }

  Future<int> insertSavedFood({
    required String name,
    String? brand,
    required String quantityLabel,
    required double calories,
    required double proteinG,
    required double carbsG,
    required double fatG,
    required bool isPer100g,
  }) {
    return into(savedFoods).insert(SavedFoodsCompanion.insert(
      name: name,
      brand: Value(brand),
      quantityLabel: quantityLabel,
      calories: calories,
      proteinG: proteinG,
      carbsG: carbsG,
      fatG: fatG,
      isPer100g: Value(isPer100g),
      savedAt: DateTime.now(),
    ));
  }

  Future<void> deleteSavedFood(int id) =>
      (delete(savedFoods)..where((f) => f.id.equals(id))).go();
}
