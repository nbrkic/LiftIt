import '../../../database/app_database.dart';
import '../../../database/queries/workout_queries.dart';
import '../../exercises/utils/exercise_stats.dart';

DateTime _startOfWeek(DateTime date) {
  final day = DateTime(date.year, date.month, date.day);
  return day.subtract(Duration(days: day.weekday - 1)); // Monday
}

// Consecutive weeks (including this one, if it already has a workout) with
// at least one finished session, counting backward from today. A still-open
// current week with no workout yet doesn't break a streak from prior weeks.
int computeStreakWeeks(List<WorkoutSession> sessions) {
  final weeksWithWorkout = sessions.map((s) => _startOfWeek(s.startedAt)).toSet();
  var week = _startOfWeek(DateTime.now());
  if (!weeksWithWorkout.contains(week)) {
    week = week.subtract(const Duration(days: 7));
  }
  var streak = 0;
  while (weeksWithWorkout.contains(week)) {
    streak++;
    week = week.subtract(const Duration(days: 7));
  }
  return streak;
}

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
  final BestSet bestSet;
  ExercisePr({required this.exerciseName, required this.exerciseId, required this.bestSet});
}

// One PR (best estimated-1RM set) per exercise, sorted strongest-first.
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
            bestSet: computeBestSet(e.value)!,
          ))
      .toList();
  prs.sort((a, b) => b.bestSet.estimated1Rm.compareTo(a.bestSet.estimated1Rm));
  return prs;
}
