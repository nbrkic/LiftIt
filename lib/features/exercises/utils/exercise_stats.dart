import '../../../database/app_database.dart';

// Epley formula: a standard, widely-used estimate of one-rep max from a
// submaximal set. Used to rank sets so a heavy single and a lighter-for-reps
// set are comparable on one "how strong was this set" scale.
double estimated1Rm(WorkoutSet set) => set.weight * (1 + set.reps / 30.0);

class BestSet {
  final WorkoutSet set;
  final double estimated1Rm;
  BestSet({required this.set, required this.estimated1Rm});
}

BestSet? computeBestSet(List<WorkoutSet> sets) {
  if (sets.isEmpty) return null;
  WorkoutSet best = sets.first;
  double bestE1rm = estimated1Rm(best);
  for (final set in sets.skip(1)) {
    final e1rm = estimated1Rm(set);
    if (e1rm > bestE1rm) {
      best = set;
      bestE1rm = e1rm;
    }
  }
  return BestSet(set: best, estimated1Rm: bestE1rm);
}

class ProgressPoint {
  final DateTime date;
  final double estimated1Rm;
  ProgressPoint({required this.date, required this.estimated1Rm});
}

// One point per calendar day: the best estimated 1RM among sets logged that day.
List<ProgressPoint> computeProgressPoints(List<WorkoutSet> sets) {
  final byDay = <DateTime, double>{};
  for (final set in sets) {
    final day = DateTime(set.completedAt.year, set.completedAt.month, set.completedAt.day);
    final e1rm = estimated1Rm(set);
    if (e1rm > (byDay[day] ?? 0)) byDay[day] = e1rm;
  }
  final points = byDay.entries.map((e) => ProgressPoint(date: e.key, estimated1Rm: e.value)).toList();
  points.sort((a, b) => a.date.compareTo(b.date));
  return points;
}
