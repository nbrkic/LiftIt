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
