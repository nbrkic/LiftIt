// Day-truncation helper shared by every feature that needs "which calendar
// day does this timestamp fall on" (rest days, history, nutrition) instead
// of each screen/provider reimplementing the same three-field constructor.
DateTime dayOf(DateTime date) => DateTime(date.year, date.month, date.day);
