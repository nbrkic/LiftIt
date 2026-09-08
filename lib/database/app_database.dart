import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'enums.dart';
import 'tables/exercises_table.dart';
import 'tables/workout_sessions_table.dart';
import 'tables/workout_sets_table.dart';
import 'tables/splits_table.dart';
import 'tables/user_profile_table.dart';
import 'tables/bodyweight_logs_table.dart';
import 'seed/exercise_seed_data.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Exercises,
    WorkoutSessions,
    WorkoutSets,
    Splits,
    SplitDays,
    SplitDayExercises,
    UserProfiles,
    BodyweightLogs,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await batch((b) {
            b.insertAll(
              exercises,
              exerciseSeedData.map(
                (e) => ExercisesCompanion.insert(
                  name: e.name,
                  primaryMuscleGroup: e.muscleGroup,
                  equipment: e.equipment,
                ),
              ),
            );
          });
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(userProfiles);
            await m.createTable(bodyweightLogs);
          }
        },
        // SQLite does not enforce FK constraints unless explicitly turned on
        // per-connection — without this, every onDelete: cascade/setNull above
        // is silently inert.
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  static QueryExecutor _openConnection() => driftDatabase(name: 'liftit_db');
}
