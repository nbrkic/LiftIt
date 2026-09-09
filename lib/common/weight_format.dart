import '../database/enums.dart';

const _kgPerLb = 0.45359237;

double kgToLb(double kg) => kg / _kgPerLb;

double lbToKg(double lb) => lb * _kgPerLb;

// Converts a canonical kg value (all storage stays kg regardless of display
// preference — see WorkoutSets.weight/BodyweightLogs.weightKg) into the
// user's preferred display unit.
double displayWeight(double kg, WeightUnit unit) => switch (unit) {
      WeightUnit.kg => kg,
      WeightUnit.lb => kgToLb(kg),
    };

// Converts a value the user typed in their preferred unit back to canonical kg.
double toCanonicalKg(double value, WeightUnit unit) => switch (unit) {
      WeightUnit.kg => value,
      WeightUnit.lb => lbToKg(value),
    };

String unitLabel(WeightUnit unit) => switch (unit) {
      WeightUnit.kg => 'kg',
      WeightUnit.lb => 'lb',
    };

// Formats a canonical kg value as "80kg" / "176.4lb" in the given unit — the
// unit is glued directly to the number, and a whole-number result never
// shows a trailing ".0" (but "52.5kg" keeps its meaningful decimal).
String formatWeight(double kg, WeightUnit unit, {int decimals = 1}) {
  final value = displayWeight(kg, unit);
  return '${_trimTrailingZeros(value, decimals)}${unitLabel(unit)}';
}

String _trimTrailingZeros(double value, int decimals) {
  var text = value.toStringAsFixed(decimals);
  if (!text.contains('.')) return text;
  while (text.endsWith('0')) {
    text = text.substring(0, text.length - 1);
  }
  if (text.endsWith('.')) text = text.substring(0, text.length - 1);
  return text;
}
