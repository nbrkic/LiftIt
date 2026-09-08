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
}
