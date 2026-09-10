import 'package:drift/drift.dart';

// A personal reusable-food list ("My Foods") — separate from FoodLogEntries,
// which is a chronological diary. Saving a food here doesn't log it; it just
// remembers its nutrition so the same values can be reused later without
// retyping them. `isPer100g` decides how a saved row gets reloaded into
// ConfirmFoodSheet: true reopens it exactly like a search/barcode match
// (editable grams, macros rescale live), false reopens it like a Gemini
// estimate (fixed quantity label, absolute macros).
class SavedFoods extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get brand => text().nullable()();
  TextColumn get quantityLabel => text()();
  RealColumn get calories => real()();
  RealColumn get proteinG => real()();
  RealColumn get carbsG => real()();
  RealColumn get fatG => real()();
  BoolColumn get isPer100g => boolean().withDefault(const Constant(false))();
  DateTimeColumn get savedAt => dateTime()();
}
