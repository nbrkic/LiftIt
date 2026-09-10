import '../../../database/app_database.dart';

// Sum of a day's logged entries, used by the diary's stat blocks/progress
// bars. Kept here (not inline in a provider) since later stages that add
// search/photo results will grow this file into the shared model file for
// the whole nutrition feature (FoodSearchResult, GeminiFoodItem, ...).
class NutritionTotals {
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;

  const NutritionTotals({
    this.calories = 0,
    this.proteinG = 0,
    this.carbsG = 0,
    this.fatG = 0,
  });

  factory NutritionTotals.fromEntries(List<FoodLogEntry> entries) {
    var calories = 0.0, protein = 0.0, carbs = 0.0, fat = 0.0;
    for (final entry in entries) {
      calories += entry.calories;
      protein += entry.proteinG;
      carbs += entry.carbsG;
      fat += entry.fatG;
    }
    return NutritionTotals(calories: calories, proteinG: protein, carbsG: carbs, fatG: fat);
  }
}
