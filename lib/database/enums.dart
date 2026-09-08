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

extension GenderLabel on Gender {
  String get label => switch (this) {
        Gender.male => 'Male',
        Gender.female => 'Female',
        Gender.other => 'Other',
        Gender.preferNotToSay => 'Prefer not to say',
      };
}

extension ExperienceLevelLabel on ExperienceLevel {
  String get label => switch (this) {
        ExperienceLevel.beginner => 'Beginner',
        ExperienceLevel.intermediate => 'Intermediate',
        ExperienceLevel.advanced => 'Advanced',
      };
}

extension TrainingGoalLabel on TrainingGoal {
  String get label => switch (this) {
        TrainingGoal.strength => 'Strength',
        TrainingGoal.hypertrophy => 'Hypertrophy',
        TrainingGoal.endurance => 'Endurance',
        TrainingGoal.weightLoss => 'Weight Loss',
        TrainingGoal.generalFitness => 'General Fitness',
      };
}

extension WeightUnitLabel on WeightUnit {
  String get label => switch (this) {
        WeightUnit.kg => 'Kilograms (kg)',
        WeightUnit.lb => 'Pounds (lb)',
      };
}

extension MuscleGroupLabel on MuscleGroup {
  String get label => switch (this) {
        MuscleGroup.chest => 'Chest',
        MuscleGroup.back => 'Back',
        MuscleGroup.shoulders => 'Shoulders',
        MuscleGroup.biceps => 'Biceps',
        MuscleGroup.triceps => 'Triceps',
        MuscleGroup.legs => 'Legs',
        MuscleGroup.glutes => 'Glutes',
        MuscleGroup.core => 'Core',
        MuscleGroup.calves => 'Calves',
        MuscleGroup.forearms => 'Forearms',
        MuscleGroup.fullBody => 'Full Body',
        MuscleGroup.cardio => 'Cardio',
      };
}

extension EquipmentLabel on Equipment {
  String get label => switch (this) {
        Equipment.barbell => 'Barbell',
        Equipment.dumbbell => 'Dumbbell',
        Equipment.machine => 'Machine',
        Equipment.cable => 'Cable',
        Equipment.bodyweight => 'Bodyweight',
        Equipment.kettlebell => 'Kettlebell',
        Equipment.band => 'Band',
        Equipment.other => 'Other',
      };
}
