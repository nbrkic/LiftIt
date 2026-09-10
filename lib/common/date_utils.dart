// Day-truncation helper shared by every feature that needs "which calendar
// day does this timestamp fall on" (rest days, history, nutrition) instead
// of each screen/provider reimplementing the same three-field constructor.
DateTime dayOf(DateTime date) => DateTime(date.year, date.month, date.day);

int? ageFrom(DateTime? birthDate) {
  if (birthDate == null) return null;
  final now = DateTime.now();
  var age = now.year - birthDate.year;
  if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
    age--;
  }
  return age;
}
