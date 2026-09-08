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

// Formats a canonical kg value as "80.0 kg" / "176.4 lb" in the given unit.
String formatWeight(double kg, WeightUnit unit, {int decimals = 1}) {
  final value = displayWeight(kg, unit);
  return '${value.toStringAsFixed(decimals)} ${unitLabel(unit)}';
}
