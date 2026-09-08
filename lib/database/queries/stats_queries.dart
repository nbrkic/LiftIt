import 'package:drift/drift.dart';
import '../app_database.dart';

class SessionVolume {
  final int sessionId;
  final DateTime startedAt;
  final double volume;
  SessionVolume({required this.sessionId, required this.startedAt, required this.volume});
}

extension StatsQueries on AppDatabase {
  Stream<List<WorkoutSet>> watchSetsForExercise(int exerciseId) {
    return (select(workoutSets)
          ..where((s) => s.exerciseId.equals(exerciseId) & s.isWarmup.equals(false))
          ..orderBy([(s) => OrderingTerm.asc(s.completedAt)]))
        .watch();
  }

  // Total volume (weight * reps, warm-ups excluded) per finished session — the
  // per-week bucketing for the chart happens in Dart, not SQL.
  Stream<List<SessionVolume>> watchSessionVolumes() {
    final totalVolume = (workoutSets.weight * workoutSets.reps.cast<double>()).sum();
    final query = selectOnly(workoutSets).join([
      innerJoin(workoutSessions, workoutSessions.id.equalsExp(workoutSets.workoutSessionId)),
    ])
      ..addColumns([totalVolume, workoutSessions.startedAt, workoutSessions.id])
      ..where(workoutSets.isWarmup.equals(false) & workoutSessions.endedAt.isNotNull())
      ..groupBy([workoutSets.workoutSessionId]);

    return query.watch().map(
          (rows) => rows
              .map((row) => SessionVolume(
                    sessionId: row.read(workoutSessions.id)!,
                    startedAt: row.read(workoutSessions.startedAt)!,
                    volume: row.read(totalVolume) ?? 0,
                  ))
              .toList(),
        );
  }
}
