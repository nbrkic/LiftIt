import 'package:drift/drift.dart';
import '../app_database.dart';
import '../enums.dart';

extension ExerciseQueries on AppDatabase {
  Stream<List<Exercise>> watchAllExercises() {
    return (select(exercises)..orderBy([(e) => OrderingTerm.asc(e.name)])).watch();
  }

  Future<int> insertCustomExercise({
    required String name,
    required MuscleGroup muscleGroup,
    required Equipment equipment,
  }) {
    return into(exercises).insert(
      ExercisesCompanion.insert(
        name: name,
        primaryMuscleGroup: muscleGroup,
        equipment: equipment,
        isCustom: const Value(true),
      ),
    );
  }

  // No onDelete on WorkoutSets.exerciseId/SplitDayExercises.exerciseId —
  // deliberately, so training history/splits can never silently disappear
  // just because an exercise got deleted. If this exercise has ever been
  // logged or planned anywhere, SQLite's foreign-key enforcement rejects
  // the delete; the caller catches that and tells the user why.
  Future<void> deleteExercise(int id) =>
      (delete(exercises)..where((e) => e.id.equals(id))).go();
}
