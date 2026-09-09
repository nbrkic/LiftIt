import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/weight_format.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/lift_button.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/profile_providers.dart';

class LogBodyweightSheet extends ConsumerStatefulWidget {
  const LogBodyweightSheet({super.key});

  @override
  ConsumerState<LogBodyweightSheet> createState() => _LogBodyweightSheetState();
}

class _LogBodyweightSheetState extends ConsumerState<LogBodyweightSheet> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final unit = ref.read(preferredWeightUnitProvider);
    final entered = double.parse(_weightController.text.replaceAll(',', '.'));
    await ref.read(profileControllerProvider).logBodyweight(
          weightKg: toCanonicalKg(entered, unit),
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final unit = ref.watch(preferredWeightUnitProvider);
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
            Text(l10n.logWeighInTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xl),
            TextFormField(
              controller: _weightController,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l10n.weightLabelWithUnit(unitLabel(unit))),
              validator: (value) =>
                  double.tryParse((value ?? '').replaceAll(',', '.')) == null ? l10n.invalid : null,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(labelText: l10n.notesOptionalLabel),
            ),
            const SizedBox(height: AppSpacing.xl),
            LiftPrimaryButton(label: l10n.logWeightButton, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
