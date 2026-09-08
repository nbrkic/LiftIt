import 'package:drift/drift.dart';
import 'workout_sessions_table.dart';
import 'exercises_table.dart';

@TableIndex(name: 'workout_set_session_idx', columns: {#workoutSessionId})
@TableIndex(
  name: 'workout_set_exercise_completed_idx',
  columns: {#exerciseId, #completedAt},
)
class WorkoutSets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workoutSessionId =>
      integer().references(WorkoutSessions, #id, onDelete: KeyAction.cascade)();

  // No cascade/setNull here (default NO ACTION): never silently orphan or
  // destroy logged sets by deleting an exercise. Exercise deletion isn't in
  // scope yet; when it ships it needs an explicit "in use" guard.
  IntColumn get exerciseId => integer().references(Exercises, #id)();
  IntColumn get setNumber => integer()();
  RealColumn get weight => real()(); // kilograms — canonical unit
  IntColumn get reps => integer()();
  RealColumn get rpe => real().nullable()();
  BoolColumn get isWarmup => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime()();
  TextColumn get notes => text().nullable()();
}
