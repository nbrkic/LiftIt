import '../../../database/queries/stats_queries.dart';

class WeeklyVolume {
  final DateTime weekStart;
  final double volume;
  WeeklyVolume({required this.weekStart, required this.volume});
}

DateTime _startOfWeek(DateTime date) {
  final day = DateTime(date.year, date.month, date.day);
  return day.subtract(Duration(days: day.weekday - 1)); // Monday
}

// Buckets session volumes into ISO-ish weeks (Monday start) and returns the
// last [weeks] weeks, oldest first, including weeks with zero volume so the
// chart doesn't silently skip gaps.
List<WeeklyVolume> computeWeeklyVolume(List<SessionVolume> sessions, {int weeks = 8}) {
  final byWeek = <DateTime, double>{};
  for (final session in sessions) {
    final weekStart = _startOfWeek(session.startedAt);
    byWeek[weekStart] = (byWeek[weekStart] ?? 0) + session.volume;
  }

  final now = _startOfWeek(DateTime.now());
  return List.generate(weeks, (i) {
    final weekStart = now.subtract(Duration(days: 7 * (weeks - 1 - i)));
    return WeeklyVolume(weekStart: weekStart, volume: byWeek[weekStart] ?? 0);
  });
}
