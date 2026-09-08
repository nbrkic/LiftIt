import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/queries/stats_queries.dart';
import '../../../database/queries/workout_queries.dart';
import '../../../providers/database_provider.dart';

final allWorkingSetsProvider = StreamProvider<List<WorkoutSetWithExercise>>((ref) {
  return ref.watch(appDatabaseProvider).watchAllWorkingSetsWithExercise();
});

final muscleGroupVolumeProvider = StreamProvider<List<MuscleGroupVolume>>((ref) {
  return ref.watch(appDatabaseProvider).watchVolumeByMuscleGroup();
});
