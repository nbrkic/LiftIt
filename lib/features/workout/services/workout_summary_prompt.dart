import '../../../database/queries/workout_queries.dart';

class _ExerciseSetSummary {
  final String name;
  final String setsDescription;
  _ExerciseSetSummary(this.name, this.setsDescription);
}

List<_ExerciseSetSummary> _groupByExercise(List<WorkoutSetWithExercise> sets) {
  final order = <int>[];
  final byExercise = <int, List<WorkoutSetWithExercise>>{};
  for (final entry in sets) {
    byExercise.putIfAbsent(entry.exercise.id, () {
      order.add(entry.exercise.id);
      return [];
    }).add(entry);
  }
  return order.map((id) {
    final group = byExercise[id]!;
    final working = group.where((e) => !e.set.isWarmup);
    final desc = working
        .map((e) =>
            '${e.set.weight % 1 == 0 ? e.set.weight.toInt() : e.set.weight}kg×${e.set.reps}')
        .join(', ');
    return _ExerciseSetSummary(group.first.exercise.name, desc.isEmpty ? 'warmup only' : desc);
  }).toList();
}

// Free-text prompt (no JSON schema needed — the output is prose meant to be
// read directly). Keeps the "coach's note" framing explicit so Gemini
// doesn't default to a generic bulleted recap.
String buildWorkoutSummaryPrompt({
  required String languageName,
  required Duration duration,
  required double volume,
  required List<WorkoutSetWithExercise> sets,
  required bool hasPr,
  Duration? previousDuration,
  double? previousVolume,
  List<WorkoutSetWithExercise>? previousSets,
}) {
  final buffer = StringBuffer()
    ..writeln('You are an experienced, encouraging strength coach reviewing a client\'s '
        'just-finished workout.')
    ..writeln('Write a short summary in $languageName: 2-4 sentences, plain prose, no '
        'headers or bullet points or markdown.')
    ..writeln('Comment on how the session went. If a previous comparable workout is given '
        'below, compare directly — was it faster or slower, was total volume or the weight '
        'used higher or lower, is there clear progress or a step back. If a personal record '
        'was hit this session, congratulate on it specifically.')
    ..writeln()
    ..writeln('THIS WORKOUT:')
    ..writeln('Duration: ${duration.inMinutes} minutes')
    ..writeln('Total volume: ${volume.round()} kg')
    ..writeln('Personal record hit: ${hasPr ? 'yes' : 'no'}')
    ..writeln('Exercises:');
  for (final group in _groupByExercise(sets)) {
    buffer.writeln('- ${group.name}: ${group.setsDescription}');
  }

  if (previousSets != null && previousDuration != null && previousVolume != null) {
    buffer
      ..writeln()
      ..writeln('PREVIOUS COMPARABLE WORKOUT:')
      ..writeln('Duration: ${previousDuration.inMinutes} minutes')
      ..writeln('Total volume: ${previousVolume.round()} kg')
      ..writeln('Exercises:');
    for (final group in _groupByExercise(previousSets)) {
      buffer.writeln('- ${group.name}: ${group.setsDescription}');
    }
  } else {
    buffer
      ..writeln()
      ..writeln('No previous comparable workout on record — this looks like the first one, '
          'so just comment on this session by itself, no comparison.');
  }

  return buffer.toString();
}
