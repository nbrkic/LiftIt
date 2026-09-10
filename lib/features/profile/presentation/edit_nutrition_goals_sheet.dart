import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/number_format_utils.dart';
import '../../../database/app_database.dart';
import '../../../database/enums.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/lift_button.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/profile_providers.dart';

// Nutrition/water goals only — basic profile info lives in its own sheet
// (EditProfileSheet). Basic fields aren't touched here, so they're passed
// straight through from `existing` on submit to avoid clobbering them.
class EditNutritionGoalsSheet extends ConsumerStatefulWidget {
  final UserProfile? existing;

  const EditNutritionGoalsSheet({super.key, this.existing});

  @override
  ConsumerState<EditNutritionGoalsSheet> createState() => _EditNutritionGoalsSheetState();
}

class _EditNutritionGoalsSheetState extends ConsumerState<EditNutritionGoalsSheet> {
  late final TextEditingController _calorieGoalController;
  late final TextEditingController _proteinGoalController;
  late final TextEditingController _carbsGoalController;
  late final TextEditingController _fatGoalController;
  late final TextEditingController _waterGoalController;

  @override
  void initState() {
    super.initState();
    final p = widget.existing;
    _calorieGoalController = TextEditingController(text: p?.dailyCalorieGoal?.toString() ?? '');
    _proteinGoalController = TextEditingController(text: p?.dailyProteinGoalG?.toString() ?? '');
    _carbsGoalController = TextEditingController(text: p?.dailyCarbsGoalG?.toString() ?? '');
    _fatGoalController = TextEditingController(text: p?.dailyFatGoalG?.toString() ?? '');
    _waterGoalController =
        TextEditingController(text: p?.dailyWaterGoalMl == null ? '' : formatLiters(p!.dailyWaterGoalMl!));
  }

  @override
  void dispose() {
    _calorieGoalController.dispose();
    _proteinGoalController.dispose();
    _carbsGoalController.dispose();
    _fatGoalController.dispose();
    _waterGoalController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final existing = widget.existing;
    final waterGoalLiters = double.tryParse(_waterGoalController.text.replaceAll(',', '.'));
    await ref.read(profileControllerProvider).saveProfile(
          name: existing?.name,
          birthDate: existing?.birthDate,
          gender: existing?.gender,
          heightCm: existing?.heightCm,
          experienceLevel: existing?.experienceLevel,
          primaryGoal: existing?.primaryGoal,
          preferredWeightUnit: existing?.preferredWeightUnit ?? WeightUnit.kg,
          weeklyTrainingGoal: existing?.weeklyTrainingGoal,
          dailyCalorieGoal: int.tryParse(_calorieGoalController.text),
          dailyProteinGoalG: int.tryParse(_proteinGoalController.text),
          dailyCarbsGoalG: int.tryParse(_carbsGoalController.text),
          dailyFatGoalG: int.tryParse(_fatGoalController.text),
          dailyWaterGoalMl: waterGoalLiters == null ? null : (waterGoalLiters * 1000).round(),
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.xxl,
        right: AppSpacing.xxl,
        top: AppSpacing.xl,
        bottom: MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).padding.bottom +
            AppSpacing.xxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l10n.editNutritionGoalsTitle, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.xl),
                  TextFormField(
                    controller: _calorieGoalController,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: l10n.dailyCalorieGoalLabel),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _proteinGoalController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: l10n.dailyProteinGoalLabel),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: TextFormField(
                          controller: _carbsGoalController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: l10n.dailyCarbsGoalLabel),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: TextFormField(
                          controller: _fatGoalController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: l10n.dailyFatGoalLabel),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _waterGoalController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(labelText: l10n.dailyWaterGoalLabel),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          LiftPrimaryButton(label: l10n.saveButton, onPressed: _submit),
        ],
      ),
    );
  }
}
