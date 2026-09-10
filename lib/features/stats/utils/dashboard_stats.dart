import '../../../database/app_database.dart';
import '../../../database/queries/workout_queries.dart';
import '../../exercises/utils/exercise_stats.dart';

double computeAverageWorkoutsPerWeek(List<WorkoutSession> sessions) {
  if (sessions.isEmpty) return 0;
  final earliest = sessions.map((s) => s.startedAt).reduce((a, b) => a.isBefore(b) ? a : b);
  final weeksElapsed = (DateTime.now().difference(earliest).inDays / 7).clamp(1, double.infinity);
  return sessions.length / weeksElapsed;
}

Duration? computeAverageDuration(List<WorkoutSession> sessions) {
  if (sessions.isEmpty) return null;
  final totalMinutes = sessions
      .map((s) => s.endedAt!.difference(s.startedAt).inMinutes)
      .reduce((a, b) => a + b);
  return Duration(minutes: (totalMinutes / sessions.length).round());
}

class ExercisePr {
  final String exerciseName;
  final int exerciseId;
  final OneRepMax oneRepMax;
  ExercisePr({required this.exerciseName, required this.exerciseId, required this.oneRepMax});
}

// One PR (tested 1RM if the user has ever logged a genuine 1-rep set,
// otherwise the best estimate) per exercise, sorted strongest-first.
List<ExercisePr> computeAllPrs(List<WorkoutSetWithExercise> allSets) {
  final byExercise = <int, List<WorkoutSet>>{};
  final names = <int, String>{};
  for (final entry in allSets) {
    byExercise.putIfAbsent(entry.exercise.id, () => []).add(entry.set);
    names[entry.exercise.id] = entry.exercise.name;
  }
  final prs = byExercise.entries
      .map((e) => ExercisePr(
            exerciseId: e.key,
            exerciseName: names[e.key]!,
            oneRepMax: computeOneRepMax(e.value)!,
          ))
      .toList();
  prs.sort((a, b) => b.oneRepMax.weight.compareTo(a.oneRepMax.weight));
  return prs;
}
