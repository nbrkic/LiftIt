import '../../../database/app_database.dart';
import '../../../l10n/app_localizations.dart';

DateTime _dayOf(DateTime date) => DateTime(date.year, date.month, date.day);

// A day counts toward the streak if it has a finished workout OR was
// explicitly marked as a planned rest day — anything else breaks it.
// Mirrors the "still-open today doesn't break a streak" rule already used
// for the weekly stats streak: today not yet trained/marked is neither
// counted nor treated as a break until it actually lapses into yesterday.
int computeDailyStreak(List<WorkoutSession> pastSessions, List<RestDay> restDays) {
  final activeDays = <DateTime>{
    ...pastSessions.map((s) => _dayOf(s.startedAt)),
    ...restDays.map((r) => _dayOf(r.date)),
  };

  var day = _dayOf(DateTime.now());
  if (!activeDays.contains(day)) {
    day = day.subtract(const Duration(days: 1));
  }
  var streak = 0;
  while (activeDays.contains(day)) {
    streak++;
    day = day.subtract(const Duration(days: 1));
  }
  return streak;
}

class StreakLevel {
  final int tier; // 1-5
  final int daysRequired;
  final String Function(AppLocalizations l10n) nameOf;

  const StreakLevel({required this.tier, required this.daysRequired, required this.nameOf});
}

// Escalating thresholds — deliberately not evenly spaced so the top tier
// (roughly a year of consistency) feels like a real achievement rather than
// a linear counter.
final streakLevels = <StreakLevel>[
  StreakLevel(tier: 1, daysRequired: 5, nameOf: (l10n) => l10n.streakLevel1Name),
  StreakLevel(tier: 2, daysRequired: 15, nameOf: (l10n) => l10n.streakLevel2Name),
  StreakLevel(tier: 3, daysRequired: 45, nameOf: (l10n) => l10n.streakLevel3Name),
  StreakLevel(tier: 4, daysRequired: 120, nameOf: (l10n) => l10n.streakLevel4Name),
  StreakLevel(tier: 5, daysRequired: 365, nameOf: (l10n) => l10n.streakLevel5Name),
];

// The highest level reached so far, or null if the streak hasn't hit tier 1 yet.
StreakLevel? currentStreakLevel(int streakDays) {
  StreakLevel? current;
  for (final level in streakLevels) {
    if (streakDays >= level.daysRequired) current = level;
  }
  return current;
}
