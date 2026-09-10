import 'package:flutter/widgets.dart';
import '../l10n/app_localizations.dart';

enum MuscleGroup {
  chest,
  back,
  shoulders,
  biceps,
  triceps,
  legs,
  glutes,
  core,
  calves,
  forearms,
  fullBody,
  cardio,
}

enum Equipment {
  barbell,
  dumbbell,
  machine,
  cable,
  bodyweight,
  kettlebell,
  band,
  other,
}

enum Gender { male, female, other, preferNotToSay }

enum ExperienceLevel { beginner, intermediate, advanced }

enum TrainingGoal { strength, hypertrophy, endurance, weightLoss, generalFitness }

enum WeightUnit { kg, lb }

enum FoodLogSource { openFoodFacts, usda, gemini, manual }

extension GenderLabel on Gender {
  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      Gender.male => l10n.genderMale,
      Gender.female => l10n.genderFemale,
      Gender.other => l10n.genderOther,
      Gender.preferNotToSay => l10n.genderPreferNotToSay,
    };
  }
}

extension ExperienceLevelLabel on ExperienceLevel {
  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      ExperienceLevel.beginner => l10n.experienceBeginner,
      ExperienceLevel.intermediate => l10n.experienceIntermediate,
      ExperienceLevel.advanced => l10n.experienceAdvanced,
    };
  }
}

extension TrainingGoalLabel on TrainingGoal {
  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      TrainingGoal.strength => l10n.goalStrength,
      TrainingGoal.hypertrophy => l10n.goalHypertrophy,
      TrainingGoal.endurance => l10n.goalEndurance,
      TrainingGoal.weightLoss => l10n.goalWeightLoss,
      TrainingGoal.generalFitness => l10n.goalGeneralFitness,
    };
  }
}

extension WeightUnitLabel on WeightUnit {
  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      WeightUnit.kg => l10n.weightUnitKg,
      WeightUnit.lb => l10n.weightUnitLb,
    };
  }
}

extension FoodLogSourceLabel on FoodLogSource {
  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      FoodLogSource.openFoodFacts => l10n.nutritionSourceOpenFoodFacts,
      FoodLogSource.usda => l10n.nutritionSourceUsda,
      FoodLogSource.gemini => l10n.nutritionSourceGemini,
      FoodLogSource.manual => l10n.nutritionSourceManual,
    };
  }
}

extension MuscleGroupLabel on MuscleGroup {
  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      MuscleGroup.chest => l10n.muscleChest,
      MuscleGroup.back => l10n.muscleBack,
      MuscleGroup.shoulders => l10n.muscleShoulders,
      MuscleGroup.biceps => l10n.muscleBiceps,
      MuscleGroup.triceps => l10n.muscleTriceps,
      MuscleGroup.legs => l10n.muscleLegs,
      MuscleGroup.glutes => l10n.muscleGlutes,
      MuscleGroup.core => l10n.muscleCore,
      MuscleGroup.calves => l10n.muscleCalves,
      MuscleGroup.forearms => l10n.muscleForearms,
      MuscleGroup.fullBody => l10n.muscleFullBody,
      MuscleGroup.cardio => l10n.muscleCardio,
    };
  }
}

extension EquipmentLabel on Equipment {
  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      Equipment.barbell => l10n.equipmentBarbell,
      Equipment.dumbbell => l10n.equipmentDumbbell,
      Equipment.machine => l10n.equipmentMachine,
      Equipment.cable => l10n.equipmentCable,
      Equipment.bodyweight => l10n.equipmentBodyweight,
      Equipment.kettlebell => l10n.equipmentKettlebell,
      Equipment.band => l10n.equipmentBand,
      Equipment.other => l10n.equipmentOther,
    };
  }
}
