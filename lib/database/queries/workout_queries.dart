import 'package:drift/drift.dart';
import '../app_database.dart';

class WorkoutSetWithExercise {
  final WorkoutSet set;
  final Exercise exercise;
  WorkoutSetWithExercise({required this.set, required this.exercise});
}

extension WorkoutQueries on AppDatabase {
  Stream<WorkoutSession?> watchActiveSession() {
    return (select(workoutSessions)
          ..where((s) => s.endedAt.isNull())
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)])
          ..limit(1))
        .watchSingleOrNull();
  }

  Future<int> startWorkoutSession({int? splitDayId}) {
    return into(workoutSessions).insert(
      WorkoutSessionsCompanion.insert(
        startedAt: DateTime.now(),
        splitDayId: Value(splitDayId),
      ),
    );
  }

  Future<void> finishWorkoutSession(int sessionId) {
    return (update(workoutSessions)..where((s) => s.id.equals(sessionId)))
        .write(WorkoutSessionsCompanion(endedAt: Value(DateTime.now())));
  }

  Stream<List<WorkoutSetWithExercise>> watchSetsForSession(int sessionId) {
    final query = select(workoutSets).join([
      innerJoin(exercises, exercises.id.equalsExp(workoutSets.exerciseId)),
    ])
      ..where(workoutSets.workoutSessionId.equals(sessionId))
      ..orderBy([OrderingTerm.asc(workoutSets.completedAt)]);
    return query.watch().map(
          (rows) => rows
              .map((row) => WorkoutSetWithExercise(
                    set: row.readTable(workoutSets),
                    exercise: row.readTable(exercises),
                  ))
              .toList(),
        );
  }

  Future<int> logSet({
    required int sessionId,
    required int exerciseId,
    required int setNumber,
    required double weight,
    required int reps,
    double? rpe,
    bool isWarmup = false,
    String? notes,
  }) {
    return into(workoutSets).insert(
      WorkoutSetsCompanion.insert(
        workoutSessionId: sessionId,
        exerciseId: exerciseId,
        setNumber: setNumber,
        weight: weight,
        reps: reps,
        rpe: Value(rpe),
        isWarmup: Value(isWarmup),
        completedAt: DateTime.now(),
        notes: Value(notes),
      ),
    );
  }

  Future<void> deleteSet(int setId) {
    return (delete(workoutSets)..where((s) => s.id.equals(setId))).go();
  }

  Stream<List<WorkoutSession>> watchPastSessions() {
    return (select(workoutSessions)
          ..where((s) => s.endedAt.isNotNull())
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)]))
        .watch();
  }

  Stream<WorkoutSession?> watchSessionById(int sessionId) {
    return (select(workoutSessions)..where((s) => s.id.equals(sessionId)))
        .watchSingleOrNull();
  }
}
