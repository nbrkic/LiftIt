import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/date_utils.dart';
import '../../../database/enums.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../profile/providers/profile_providers.dart';
import '../services/calorie_calculator.dart';

class BmiCalculatorScreen extends ConsumerStatefulWidget {
  const BmiCalculatorScreen({super.key});

  @override
  ConsumerState<BmiCalculatorScreen> createState() => _BmiCalculatorScreenState();
}

class _BmiCalculatorScreenState extends ConsumerState<BmiCalculatorScreen> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();
  Gender? _gender;
  ActivityLevel _activityLevel = ActivityLevel.moderate;
  bool _weightSynced = false;
  bool _profileSynced = false;

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  double? get _weight => double.tryParse(_weightController.text.replaceAll(',', '.'));
  double? get _height => double.tryParse(_heightController.text.replaceAll(',', '.'));
  int? get _age => int.tryParse(_ageController.text);

  Future<void> _setAsGoal(NutritionGoalPreset preset) async {
    final l10n = AppLocalizations.of(context)!;
    final existing = ref.read(userProfileProvider).value;
    await ref.read(profileControllerProvider).saveProfile(
          name: existing?.name,
          birthDate: existing?.birthDate,
          gender: existing?.gender,
          heightCm: existing?.heightCm,
          experienceLevel: existing?.experienceLevel,
          primaryGoal: existing?.primaryGoal,
          preferredWeightUnit: existing?.preferredWeightUnit ?? WeightUnit.kg,
          weeklyTrainingGoal: existing?.weeklyTrainingGoal,
          dailyCalorieGoal: preset.calories.round(),
          dailyProteinGoalG: preset.proteinG.round(),
          dailyCarbsGoalG: preset.carbsG.round(),
          dailyFatGoalG: preset.fatG.round(),
          dailyWaterGoalMl: existing?.dailyWaterGoalMl,
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.bmiGoalSetConfirmation(preset.type.label(context)))));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final profile = ref.watch(userProfileProvider).value;
    final latestBodyweight = ref.watch(latestBodyweightProvider).value;

    // Profile/bodyweight load asynchronously (and don't necessarily resolve
    // on the same frame) — sync each field once its real value arrives
    // instead of relying on TextFormField's initialValue, which only
    // applies once. After that the fields are the user's to edit freely.
    if (!_weightSynced && latestBodyweight != null) {
      _weightController.text = latestBodyweight.weightKg.round().toString();
      _weightSynced = true;
    }
    if (!_profileSynced && profile != null) {
      _heightController.text = profile.heightCm?.round().toString() ?? '';
      _ageController.text = ageFrom(profile.birthDate)?.toString() ?? '';
      _gender = profile.gender;
      _profileSynced = true;
    }

    final weight = _weight;
    final height = _height;
    final age = _age;
    final bmi = (weight != null && height != null && weight > 0 && height > 0)
        ? calculateBmi(weightKg: weight, heightCm: height)
        : null;
    final tdee = (weight != null && height != null && age != null && weight > 0 && height > 0)
        ? calculateTdee(weightKg: weight, heightCm: height, age: age, gender: _gender, activityLevel: _activityLevel)
        : null;
    final presets = (tdee != null && weight != null)
        ? GoalPresetType.values
            .map((type) => calculateGoalPreset(type: type, tdee: tdee, weightKg: weight))
            .toList()
        : const <NutritionGoalPreset>[];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.bmiCalculatorTitle)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          children: [
            TextFormField(
              controller: _weightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l10n.bmiWeightLabel),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _heightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l10n.heightLabel),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.bmiAgeLabel),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<Gender>(
              initialValue: _gender,
              decoration: InputDecoration(labelText: l10n.genderLabel),
              items: Gender.values
                  .map((g) => DropdownMenuItem(value: g, child: Text(g.label(context))))
                  .toList(),
              onChanged: (value) => setState(() => _gender = value),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<ActivityLevel>(
              initialValue: _activityLevel,
              decoration: InputDecoration(labelText: l10n.bmiActivityLevelLabel),
              items: ActivityLevel.values
                  .map((a) => DropdownMenuItem(value: a, child: Text(a.label(context))))
                  .toList(),
              onChanged: (value) => setState(() => _activityLevel = value!),
            ),
            const SizedBox(height: AppSpacing.xxl),
            if (bmi != null) ...[
              Text(l10n.bmiResultLabel(bmi.toStringAsFixed(1)), style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(
                bmiCategoryOf(bmi).label(context),
                style: theme.textTheme.bodyMedium?.copyWith(color: c.textSecondary),
              ),
              const SizedBox(height: AppSpacing.lg),
              _BmiScale(bmi: bmi),
            ] else
              Text(
                l10n.bmiMissingInputsHint,
                style: theme.textTheme.bodyMedium?.copyWith(color: c.textSecondary),
              ),
            const SizedBox(height: AppSpacing.xxl),
            Text(l10n.bmiGoalsSectionLabel.toUpperCase(), style: theme.textTheme.labelMedium),
            Divider(height: AppSpacing.xl, color: c.divider),
            if (presets.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Text(
                  l10n.bmiGoalsMissingInputsHint,
                  style: theme.textTheme.bodyMedium?.copyWith(color: c.textSecondary),
                ),
              )
            else
              ...presets.map((preset) => _GoalPresetRow(
                    preset: preset,
                    onSetAsGoal: () => _setAsGoal(preset),
                  )),
          ],
        ),
      ),
    );
  }
}

// A colored ruler spanning a fixed 15-40 BMI range with an arrow marking
// where the user's value falls — underweight/overweight both read as
// "caution" (warning), obese as "danger", the healthy band as "success".
class _BmiScale extends StatelessWidget {
  final double bmi;

  const _BmiScale({required this.bmi});

  static const _min = 15.0;
  static const _max = 40.0;
  // Flex weights for the 15-18.5 / 18.5-25 / 25-30 / 30-40 bands, scaled
  // ×10 so each stays an integer (Row flex requires int).
  static const _underweightFlex = 35;
  static const _normalFlex = 65;
  static const _overweightFlex = 50;
  static const _obeseFlex = 100;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fraction = ((bmi.clamp(_min, _max) - _min) / (_max - _min)).toDouble();

    return LayoutBuilder(
      builder: (context, constraints) {
        const markerSize = 24.0;
        final markerLeft =
            (fraction * constraints.maxWidth - markerSize / 2).clamp(0.0, constraints.maxWidth - markerSize);
        return SizedBox(
          height: 34,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 18,
                left: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Row(
                    children: [
                      Expanded(flex: _underweightFlex, child: Container(height: 6, color: c.warning)),
                      Expanded(flex: _normalFlex, child: Container(height: 6, color: c.success)),
                      Expanded(flex: _overweightFlex, child: Container(height: 6, color: c.warning)),
                      Expanded(flex: _obeseFlex, child: Container(height: 6, color: c.danger)),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: markerLeft,
                top: 0,
                child: Icon(Icons.arrow_drop_down, size: markerSize, color: c.textPrimary),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GoalPresetRow extends StatelessWidget {
  final NutritionGoalPreset preset;
  final VoidCallback onSetAsGoal;

  const _GoalPresetRow({required this.preset, required this.onSetAsGoal});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(preset.type.label(context), style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 2),
                  Text(
                    '${preset.calories.round()} ${l10n.nutritionCaloriesUnitShort} • '
                    'P ${preset.proteinG.round()}g • C ${preset.carbsG.round()}g • F ${preset.fatG.round()}g',
                    style: theme.textTheme.bodySmall?.copyWith(color: c.textSecondary),
                  ),
                ],
              ),
            ),
            TextButton(onPressed: onSetAsGoal, child: Text(l10n.bmiSetAsGoalAction)),
          ],
        ),
        Divider(height: AppSpacing.xl, color: c.divider),
      ],
    );
  }
}
