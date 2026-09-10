import '../../../database/app_database.dart';
import '../../../database/enums.dart';

// A text-search/barcode-lookup match, always expressed per 100g — the
// common shape both Open Food Facts and USDA results are normalized into so
// they render in one merged list and share the same quantity-scaling math.
class FoodSearchResult {
  final String name;
  final String? brand;
  final double caloriesPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatPer100g;
  final FoodLogSource source;
  final String? sourceId;

  const FoodSearchResult({
    required this.name,
    this.brand,
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatPer100g,
    required this.source,
    this.sourceId,
  });
}

// A single recognized item in a food photo — already an absolute estimate
// (not per-100g), since a photo shows a real plate, not a reference amount.
class GeminiFoodItem {
  final String name;
  final String quantityLabel;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;

  const GeminiFoodItem({
    required this.name,
    required this.quantityLabel,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });
}

class ScaledNutrition {
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;

  const ScaledNutrition({
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });
}

ScaledNutrition scaleToQuantity(FoodSearchResult result, double grams) {
  final factor = grams / 100;
  return ScaledNutrition(
    calories: result.caloriesPer100g * factor,
    proteinG: result.proteinPer100g * factor,
    carbsG: result.carbsPer100g * factor,
    fatG: result.fatPer100g * factor,
  );
}

// Thrown by every nutrition API service so every screen can surface network/
// parsing failures through the app's existing AsyncValue.error ->
// l10n.errorMessage convention, regardless of which source failed.
class NutritionApiException implements Exception {
  final String message;
  const NutritionApiException(this.message);

  @override
  String toString() => message;
}

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
