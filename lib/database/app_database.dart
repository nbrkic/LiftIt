import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'enums.dart';
import 'tables/exercises_table.dart';
import 'tables/workout_sessions_table.dart';
import 'tables/workout_sets_table.dart';
import 'tables/splits_table.dart';
import 'tables/user_profile_table.dart';
import 'tables/bodyweight_logs_table.dart';
import 'tables/rest_days_table.dart';
import 'tables/food_log_entries_table.dart';
import 'tables/saved_foods_table.dart';
import 'tables/water_logs_table.dart';
import 'tables/supplements_table.dart';
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
    RestDays,
    FoodLogEntries,
    SavedFoods,
    WaterLogs,
    Supplements,
    SupplementLogs,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 9;

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
          if (from < 3) {
            await m.addColumn(workoutSets, workoutSets.notes);
          }
          if (from < 4) {
            await m.createTable(restDays);
          }
          if (from < 5) {
            await m.createTable(foodLogEntries);
            await m.addColumn(userProfiles, userProfiles.dailyCalorieGoal);
            await m.addColumn(userProfiles, userProfiles.dailyProteinGoalG);
            await m.addColumn(userProfiles, userProfiles.dailyCarbsGoalG);
            await m.addColumn(userProfiles, userProfiles.dailyFatGoalG);
          }
          if (from < 6) {
            await m.createTable(savedFoods);
          }
          if (from < 7) {
            await m.createTable(waterLogs);
            await m.addColumn(userProfiles, userProfiles.dailyWaterGoalMl);
          }
          if (from < 8) {
            await m.createTable(supplements);
            await m.createTable(supplementLogs);
          }
          if (from < 9) {
            await m.addColumn(workoutSessions, workoutSessions.aiSummary);
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
