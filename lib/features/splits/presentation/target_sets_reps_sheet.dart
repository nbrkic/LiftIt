import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/app_database.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/lift_button.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/split_providers.dart';

class TargetSetsRepsSheet extends ConsumerStatefulWidget {
  final Exercise exercise;
  final int splitDayId;

  const TargetSetsRepsSheet({super.key, required this.exercise, required this.splitDayId});

  @override
  ConsumerState<TargetSetsRepsSheet> createState() => _TargetSetsRepsSheetState();
}

class _TargetSetsRepsSheetState extends ConsumerState<TargetSetsRepsSheet> {
  final _formKey = GlobalKey<FormState>();
  final _setsController = TextEditingController(text: '3');
  final _repsLowController = TextEditingController();
  final _repsHighController = TextEditingController();

  @override
  void dispose() {
    _setsController.dispose();
    _repsLowController.dispose();
    _repsHighController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(splitControllerProvider).addExerciseToDay(
          splitDayId: widget.splitDayId,
          exerciseId: widget.exercise.id,
          targetSets: int.parse(_setsController.text),
          targetRepsLow: int.tryParse(_repsLowController.text),
          targetRepsHigh: int.tryParse(_repsHighController.text),
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
            Text(widget.exercise.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xl),
            TextFormField(
              controller: _setsController,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.targetSetsLabel),
              validator: (value) => int.tryParse(value ?? '') == null ? l10n.invalid : null,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _repsLowController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: l10n.repsFromOptionalLabel),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextFormField(
                    controller: _repsHighController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: l10n.repsToOptionalLabel),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            LiftPrimaryButton(label: l10n.addToDayButton, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
