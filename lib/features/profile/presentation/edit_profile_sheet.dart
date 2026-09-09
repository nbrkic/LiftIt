import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/app_database.dart';
import '../../../database/enums.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/lift_button.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/profile_providers.dart';

class EditProfileSheet extends ConsumerStatefulWidget {
  final UserProfile? existing;

  const EditProfileSheet({super.key, this.existing});

  @override
  ConsumerState<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _heightController;
  late final TextEditingController _weeklyGoalController;
  DateTime? _birthDate;
  Gender? _gender;
  ExperienceLevel? _experienceLevel;
  TrainingGoal? _primaryGoal;
  late WeightUnit _weightUnit;

  @override
  void initState() {
    super.initState();
    final p = widget.existing;
    _nameController = TextEditingController(text: p?.name ?? '');
    _heightController = TextEditingController(text: p?.heightCm?.toString() ?? '');
    _weeklyGoalController = TextEditingController(text: p?.weeklyTrainingGoal?.toString() ?? '');
    _birthDate = p?.birthDate;
    _gender = p?.gender;
    _experienceLevel = p?.experienceLevel;
    _primaryGoal = p?.primaryGoal;
    _weightUnit = p?.preferredWeightUnit ?? WeightUnit.kg;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weeklyGoalController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 25),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(profileControllerProvider).saveProfile(
          name: _nameController.text.trim().isEmpty ? null : _nameController.text.trim(),
          birthDate: _birthDate,
          gender: _gender,
          heightCm: double.tryParse(_heightController.text.replaceAll(',', '.')),
          experienceLevel: _experienceLevel,
          primaryGoal: _primaryGoal,
          preferredWeightUnit: _weightUnit,
          weeklyTrainingGoal: int.tryParse(_weeklyGoalController.text),
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
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.editProfileTitle, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.xl),
              TextFormField(
                controller: _nameController,
                autofocus: true,
                decoration: InputDecoration(labelText: l10n.nameLabel),
              ),
              const SizedBox(height: AppSpacing.md),
              InkWell(
                onTap: _pickBirthDate,
                child: InputDecorator(
                  decoration: InputDecoration(labelText: l10n.dateOfBirthLabel),
                  child: Text(
                    _birthDate == null
                        ? l10n.notSet
                        : '${_birthDate!.day.toString().padLeft(2, '0')}.${_birthDate!.month.toString().padLeft(2, '0')}.${_birthDate!.year}',
                  ),
                ),
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
              TextFormField(
                controller: _heightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: l10n.heightLabel),
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<ExperienceLevel>(
                initialValue: _experienceLevel,
                decoration: InputDecoration(labelText: l10n.experienceLevelLabel),
                items: ExperienceLevel.values
                    .map((e) => DropdownMenuItem(value: e, child: Text(e.label(context))))
                    .toList(),
                onChanged: (value) => setState(() => _experienceLevel = value),
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<TrainingGoal>(
                initialValue: _primaryGoal,
                decoration: InputDecoration(labelText: l10n.primaryGoalLabel),
                items: TrainingGoal.values
                    .map((g) => DropdownMenuItem(value: g, child: Text(g.label(context))))
                    .toList(),
                onChanged: (value) => setState(() => _primaryGoal = value),
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<WeightUnit>(
                initialValue: _weightUnit,
                decoration: InputDecoration(labelText: l10n.preferredWeightUnitLabel),
                items: WeightUnit.values
                    .map((u) => DropdownMenuItem(value: u, child: Text(u.label(context))))
                    .toList(),
                onChanged: (value) => setState(() => _weightUnit = value!),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _weeklyGoalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.weeklyTrainingGoalLabel),
              ),
              const SizedBox(height: AppSpacing.xl),
              LiftPrimaryButton(label: l10n.saveButton, onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
