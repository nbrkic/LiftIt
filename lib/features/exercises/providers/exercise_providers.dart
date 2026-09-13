import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/app_database.dart';
import '../../../database/enums.dart';
import '../../../database/queries/exercise_queries.dart';
import '../../../providers/database_provider.dart';

final exerciseListProvider = StreamProvider<List<Exercise>>((ref) {
  return ref.watch(appDatabaseProvider).watchAllExercises();
});

final deleteExerciseProvider = Provider<Future<void> Function(int id)>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (id) => db.deleteExercise(id);
});

final addCustomExerciseProvider =
    Provider<Future<int> Function({required String name, required MuscleGroup muscleGroup, required Equipment equipment})>(
  (ref) {
    final db = ref.watch(appDatabaseProvider);
    return ({required name, required muscleGroup, required equipment}) =>
        db.insertCustomExercise(name: name, muscleGroup: muscleGroup, equipment: equipment);
  },
);
