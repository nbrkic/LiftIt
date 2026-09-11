import '../../../database/app_database.dart';

class WeeklyNutrition {
  final DateTime weekStart;
  final double avgCalories;
  final double avgProteinG;
  final double avgCarbsG;
  final double avgFatG;

  const WeeklyNutrition({
    required this.weekStart,
    required this.avgCalories,
    required this.avgProteinG,
    required this.avgCarbsG,
    required this.avgFatG,
  });
}

class _WeekTotals {
  double calories = 0;
  double proteinG = 0;
  double carbsG = 0;
  double fatG = 0;
}

DateTime _startOfWeek(DateTime date) {
  final day = DateTime(date.year, date.month, date.day);
  return day.subtract(Duration(days: day.weekday - 1)); // Monday
}

// Buckets logged food into Monday-start weeks (same convention as
// computeWeeklyVolume) and averages each week's total across the full
// 7-day week, not just the days something was logged — a quiet week pulls
// the average down instead of being silently excluded, and the result is
// directly comparable to the daily goals shown in the diary.
List<WeeklyNutrition> computeWeeklyNutrition(List<FoodLogEntry> entries, {int weeks = 8}) {
  final byWeek = <DateTime, _WeekTotals>{};
  for (final entry in entries) {
    final weekStart = _startOfWeek(entry.loggedAt);
    final totals = byWeek.putIfAbsent(weekStart, () => _WeekTotals());
    totals.calories += entry.calories;
    totals.proteinG += entry.proteinG;
    totals.carbsG += entry.carbsG;
    totals.fatG += entry.fatG;
  }

  final now = _startOfWeek(DateTime.now());
  return List.generate(weeks, (i) {
    final weekStart = now.subtract(Duration(days: 7 * (weeks - 1 - i)));
    final totals = byWeek[weekStart];
    return WeeklyNutrition(
      weekStart: weekStart,
      avgCalories: (totals?.calories ?? 0) / 7,
      avgProteinG: (totals?.proteinG ?? 0) / 7,
      avgCarbsG: (totals?.carbsG ?? 0) / 7,
      avgFatG: (totals?.fatG ?? 0) / 7,
    );
  });
}
