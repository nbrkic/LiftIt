import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/lift_button.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/supplement_providers.dart';

class AddSupplementSheet extends ConsumerStatefulWidget {
  const AddSupplementSheet({super.key});

  @override
  ConsumerState<AddSupplementSheet> createState() => _AddSupplementSheetState();
}

class _AddSupplementSheetState extends ConsumerState<AddSupplementSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(supplementControllerProvider).addSupplement(
          name: _nameController.text.trim(),
          dosageLabel: _dosageController.text.trim(),
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
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.nutritionAddSupplementTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xl),
            TextFormField(
              controller: _nameController,
              autofocus: true,
              decoration: InputDecoration(labelText: l10n.nutritionSupplementNameLabel),
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? l10n.enterAName : null,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _dosageController,
              decoration: InputDecoration(labelText: l10n.nutritionSupplementDosageLabel),
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? l10n.enterAName : null,
            ),
            const SizedBox(height: AppSpacing.xl),
            LiftPrimaryButton(label: l10n.saveButton, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
