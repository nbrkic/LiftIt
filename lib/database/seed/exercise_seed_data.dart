import '../enums.dart';

// Deliberately imports only enums.dart, never app_database.dart — app_database.dart
// imports this file for onCreate seeding, so the reverse import would be circular.
class ExerciseSeed {
  final String name;
  final MuscleGroup muscleGroup;
  final Equipment equipment;
  const ExerciseSeed(this.name, this.muscleGroup, this.equipment);
}

const List<ExerciseSeed> exerciseSeedData = [
  // Chest
  ExerciseSeed('Barbell Bench Press', MuscleGroup.chest, Equipment.barbell),
  ExerciseSeed('Incline Barbell Bench Press', MuscleGroup.chest, Equipment.barbell),
  ExerciseSeed('Incline Dumbbell Press', MuscleGroup.chest, Equipment.dumbbell),
  ExerciseSeed('Dumbbell Fly', MuscleGroup.chest, Equipment.dumbbell),
  ExerciseSeed('Cable Fly', MuscleGroup.chest, Equipment.cable),
  ExerciseSeed('Push-up', MuscleGroup.chest, Equipment.bodyweight),
  ExerciseSeed('Chest Press Machine', MuscleGroup.chest, Equipment.machine),

  // Back
  ExerciseSeed('Conventional Deadlift', MuscleGroup.back, Equipment.barbell),
  ExerciseSeed('Pull-up', MuscleGroup.back, Equipment.bodyweight),
  ExerciseSeed('Lat Pulldown', MuscleGroup.back, Equipment.cable),
  ExerciseSeed('Barbell Row', MuscleGroup.back, Equipment.barbell),
  ExerciseSeed('Seated Cable Row', MuscleGroup.back, Equipment.cable),
  ExerciseSeed('One-Arm Dumbbell Row', MuscleGroup.back, Equipment.dumbbell),
  ExerciseSeed('Face Pull', MuscleGroup.back, Equipment.cable),

  // Shoulders
  ExerciseSeed('Overhead Press', MuscleGroup.shoulders, Equipment.barbell),
  ExerciseSeed('Seated Dumbbell Shoulder Press', MuscleGroup.shoulders, Equipment.dumbbell),
  ExerciseSeed('Lateral Raise', MuscleGroup.shoulders, Equipment.dumbbell),
  ExerciseSeed('Rear Delt Fly', MuscleGroup.shoulders, Equipment.dumbbell),
  ExerciseSeed('Arnold Press', MuscleGroup.shoulders, Equipment.dumbbell),

  // Biceps
  ExerciseSeed('Barbell Curl', MuscleGroup.biceps, Equipment.barbell),
  ExerciseSeed('Dumbbell Curl', MuscleGroup.biceps, Equipment.dumbbell),
  ExerciseSeed('Hammer Curl', MuscleGroup.biceps, Equipment.dumbbell),
  ExerciseSeed('Cable Curl', MuscleGroup.biceps, Equipment.cable),

  // Triceps
  ExerciseSeed('Triceps Pushdown', MuscleGroup.triceps, Equipment.cable),
  ExerciseSeed('Skull Crusher', MuscleGroup.triceps, Equipment.barbell),
  ExerciseSeed('Overhead Triceps Extension', MuscleGroup.triceps, Equipment.dumbbell),
  ExerciseSeed('Close-Grip Bench Press', MuscleGroup.triceps, Equipment.barbell),
  ExerciseSeed('Dip', MuscleGroup.triceps, Equipment.bodyweight),

  // Legs
  ExerciseSeed('Barbell Back Squat', MuscleGroup.legs, Equipment.barbell),
  ExerciseSeed('Front Squat', MuscleGroup.legs, Equipment.barbell),
  ExerciseSeed('Romanian Deadlift', MuscleGroup.legs, Equipment.barbell),
  ExerciseSeed('Leg Press', MuscleGroup.legs, Equipment.machine),
  ExerciseSeed('Leg Extension', MuscleGroup.legs, Equipment.machine),
  ExerciseSeed('Leg Curl', MuscleGroup.legs, Equipment.machine),
  ExerciseSeed('Walking Lunge', MuscleGroup.legs, Equipment.dumbbell),
  ExerciseSeed('Bulgarian Split Squat', MuscleGroup.legs, Equipment.dumbbell),

  // Glutes
  ExerciseSeed('Hip Thrust', MuscleGroup.glutes, Equipment.barbell),
  ExerciseSeed('Cable Kickback', MuscleGroup.glutes, Equipment.cable),

  // Calves
  ExerciseSeed('Standing Calf Raise', MuscleGroup.calves, Equipment.machine),
  ExerciseSeed('Seated Calf Raise', MuscleGroup.calves, Equipment.machine),

  // Core
  ExerciseSeed('Plank', MuscleGroup.core, Equipment.bodyweight),
  ExerciseSeed('Hanging Leg Raise', MuscleGroup.core, Equipment.bodyweight),
  ExerciseSeed('Cable Crunch', MuscleGroup.core, Equipment.cable),
  ExerciseSeed('Russian Twist', MuscleGroup.core, Equipment.bodyweight),

  // Forearms
  ExerciseSeed('Wrist Curl', MuscleGroup.forearms, Equipment.dumbbell),
  ExerciseSeed('Farmer\'s Carry', MuscleGroup.forearms, Equipment.dumbbell),

  // Full body / cardio
  ExerciseSeed('Kettlebell Swing', MuscleGroup.fullBody, Equipment.kettlebell),
  ExerciseSeed('Burpee', MuscleGroup.fullBody, Equipment.bodyweight),
  ExerciseSeed('Treadmill Run', MuscleGroup.cardio, Equipment.other),
  ExerciseSeed('Rowing Machine', MuscleGroup.cardio, Equipment.machine),
];
