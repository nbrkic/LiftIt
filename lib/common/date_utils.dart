// Day-truncation helper shared by every feature that needs "which calendar
// day does this timestamp fall on" (rest days, history, nutrition) instead
// of each screen/provider reimplementing the same three-field constructor.
DateTime dayOf(DateTime date) => DateTime(date.year, date.month, date.day);

// Combines a target calendar day with the current wall-clock time — used
// when logging to a day other than today (browsing history in the nutrition
// diary), so entries for a past day still order sensibly by when they were
// actually added instead of all collapsing to midnight.
DateTime combineDayWithCurrentTime(DateTime day) {
  final now = DateTime.now();
  return DateTime(day.year, day.month, day.day, now.hour, now.minute, now.second, now.millisecond);
}

int? ageFrom(DateTime? birthDate) {
  if (birthDate == null) return null;
  final now = DateTime.now();
  var age = now.year - birthDate.year;
  if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
    age--;
  }
  return age;
}
