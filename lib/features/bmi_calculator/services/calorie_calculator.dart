import 'package:flutter/widgets.dart';
import '../../../database/enums.dart';
import '../../../l10n/app_localizations.dart';

// Standard, well-established formulas — deliberately not an AI/LLM call.
// The numbers below (Mifflin-St Jeor, activity multipliers, cut/bulk
// percentages, g/kg protein targets) are the same ones any fitness app or
// a prompted LLM would apply; computing them locally is instant, works
// offline, needs no API key, and gives the same answer every time for the
// same inputs instead of varying between calls.

double calculateBmi({required double weightKg, required double heightCm}) {
  final heightM = heightCm / 100;
  return weightKg / (heightM * heightM);
}

enum BmiCategory { underweight, normal, overweight, obese }

BmiCategory bmiCategoryOf(double bmi) {
  if (bmi < 18.5) return BmiCategory.underweight;
  if (bmi < 25) return BmiCategory.normal;
  if (bmi < 30) return BmiCategory.overweight;
  return BmiCategory.obese;
}

extension BmiCategoryLabel on BmiCategory {
  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      BmiCategory.underweight => l10n.bmiCategoryUnderweight,
      BmiCategory.normal => l10n.bmiCategoryNormal,
      BmiCategory.overweight => l10n.bmiCategoryOverweight,
      BmiCategory.obese => l10n.bmiCategoryObese,
    };
  }
}

enum ActivityLevel { sedentary, light, moderate, active, veryActive }

extension ActivityLevelMultiplier on ActivityLevel {
  double get multiplier => switch (this) {
        ActivityLevel.sedentary => 1.2,
        ActivityLevel.light => 1.375,
        ActivityLevel.moderate => 1.55,
        ActivityLevel.active => 1.725,
        ActivityLevel.veryActive => 1.9,
      };

  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      ActivityLevel.sedentary => l10n.activityLevelSedentary,
      ActivityLevel.light => l10n.activityLevelLight,
      ActivityLevel.moderate => l10n.activityLevelModerate,
      ActivityLevel.active => l10n.activityLevelActive,
      ActivityLevel.veryActive => l10n.activityLevelVeryActive,
    };
  }
}

// Mifflin-St Jeor — the most accurate widely-used BMR equation for the
// general population. Gender changes only the fixed offset; when gender is
// unset/other/prefer-not-to-say there's no third equation to fall back on,
// so the average of the male/female offset is used as a neutral estimate.
double calculateBmr({
  required double weightKg,
  required double heightCm,
  required int age,
  required Gender? gender,
}) {
  final base = 10 * weightKg + 6.25 * heightCm - 5 * age;
  final genderOffset = switch (gender) {
    Gender.male => 5,
    Gender.female => -161,
    _ => -78,
  };
  return base + genderOffset;
}

double calculateTdee({
  required double weightKg,
  required double heightCm,
  required int age,
  required Gender? gender,
  required ActivityLevel activityLevel,
}) {
  return calculateBmr(weightKg: weightKg, heightCm: heightCm, age: age, gender: gender) *
      activityLevel.multiplier;
}

enum GoalPresetType { aggressiveCut, cut, maintenance, bulk, aggressiveBulk }

extension GoalPresetTypeConfig on GoalPresetType {
  double get calorieMultiplier => switch (this) {
        GoalPresetType.aggressiveCut => 0.75,
        GoalPresetType.cut => 0.80,
        GoalPresetType.maintenance => 1.0,
        GoalPresetType.bulk => 1.10,
        GoalPresetType.aggressiveBulk => 1.20,
      };

  // Higher protein on a cut helps preserve muscle in a deficit; a surplus
  // already spares muscle, so bulking needs less.
  double get proteinGPerKg => switch (this) {
        GoalPresetType.aggressiveCut || GoalPresetType.cut => 2.2,
        GoalPresetType.maintenance => 2.0,
        GoalPresetType.bulk || GoalPresetType.aggressiveBulk => 1.8,
      };

  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      GoalPresetType.aggressiveCut => l10n.bmiGoalAggressiveCut,
      GoalPresetType.cut => l10n.bmiGoalCut,
      GoalPresetType.maintenance => l10n.bmiGoalMaintenance,
      GoalPresetType.bulk => l10n.bmiGoalBulk,
      GoalPresetType.aggressiveBulk => l10n.bmiGoalAggressiveBulk,
    };
  }
}

class NutritionGoalPreset {
  final GoalPresetType type;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;

  const NutritionGoalPreset({
    required this.type,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });
}

// Fat set to 25% of calories (covers hormonal-health minimums for virtually
// any realistic calorie target here), protein from g/kg bodyweight, carbs
// fill whatever's left.
NutritionGoalPreset calculateGoalPreset({
  required GoalPresetType type,
  required double tdee,
  required double weightKg,
}) {
  final calories = tdee * type.calorieMultiplier;
  final proteinG = type.proteinGPerKg * weightKg;
  final proteinCalories = proteinG * 4;
  final fatCalories = calories * 0.25;
  final fatG = fatCalories / 9;
  final carbsCalories = calories - proteinCalories - fatCalories;
  final carbsG = carbsCalories < 0 ? 0.0 : carbsCalories / 4;
  return NutritionGoalPreset(
    type: type,
    calories: calories,
    proteinG: proteinG,
    carbsG: carbsG,
    fatG: fatG,
  );
}
