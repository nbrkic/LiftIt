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

class OneRepMax {
  final WorkoutSet set;
  final double weight; // kg — actual weight if tested, Epley estimate otherwise
  final bool isTested; // true when a real 1-rep set was logged, not just estimated
  OneRepMax({required this.set, required this.weight, required this.isTested});
}

// Prefers a genuinely tested 1RM (the heaviest set the user has ever logged
// with exactly 1 rep — that IS their 1RM, no formula needed) over the Epley
// estimate. Falls back to the estimate only when no single-rep set exists.
OneRepMax? computeOneRepMax(List<WorkoutSet> sets) {
  if (sets.isEmpty) return null;

  final trueMaxAttempts = sets.where((s) => s.reps == 1).toList();
  if (trueMaxAttempts.isNotEmpty) {
    trueMaxAttempts.sort((a, b) => b.weight.compareTo(a.weight));
    final best = trueMaxAttempts.first;
    return OneRepMax(set: best, weight: best.weight, isTested: true);
  }

  final best = computeBestSet(sets)!;
  return OneRepMax(set: best.set, weight: best.estimated1Rm, isTested: false);
}

// The sets from the most recent session that touched this exercise, other
// than the given (typically active) session — "Last time: 80x8, 80x8..."
// `allSets` must already be ordered ascending by completedAt (as returned by
// watchSetsForExercise), so the most recent prior session is whichever one
// the last non-excluded entry belongs to.
List<WorkoutSet> previousSessionSets(List<WorkoutSet> allSets, int excludingSessionId) {
  final prior = allSets.where((s) => s.workoutSessionId != excludingSessionId).toList();
  if (prior.isEmpty) return const [];
  final lastSessionId = prior.last.workoutSessionId;
  return prior.where((s) => s.workoutSessionId == lastSessionId).toList();
}

// One "top set" per training session — the heaviest non-warm-up set logged
// for this exercise that session (in most training styles that's simply the
// first working set). Tracks real logged weight/reps progress over time,
// not a formula-derived estimate — that's what computeOneRepMax is for.
List<WorkoutSet> computeTopSetProgress(List<WorkoutSet> sets) {
  final bySession = <int, WorkoutSet>{};
  for (final set in sets) {
    if (set.isWarmup) continue;
    final current = bySession[set.workoutSessionId];
    if (current == null || set.weight > current.weight) {
      bySession[set.workoutSessionId] = set;
    }
  }
  final topSets = bySession.values.toList();
  topSets.sort((a, b) => a.completedAt.compareTo(b.completedAt));
  return topSets;
}
