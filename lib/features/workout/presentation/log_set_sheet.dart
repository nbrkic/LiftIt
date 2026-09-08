import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/weight_format.dart';
import '../../../database/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../profile/providers/profile_providers.dart';
import '../providers/active_workout_providers.dart';

class LogSetSheet extends ConsumerStatefulWidget {
  final Exercise exercise;
  final int sessionId;
  final int nextSetNumber;

  const LogSetSheet({
    super.key,
    required this.exercise,
    required this.sessionId,
    required this.nextSetNumber,
  });

  @override
  ConsumerState<LogSetSheet> createState() => _LogSetSheetState();
}

class _LogSetSheetState extends ConsumerState<LogSetSheet> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();
  final _rpeController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isWarmup = false;

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    _rpeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final unit = ref.read(preferredWeightUnitProvider);
    final enteredWeight = double.parse(_weightController.text.replaceAll(',', '.'));
    final rpeText = _rpeController.text.trim();
    final notesText = _notesController.text.trim();
    await ref.read(activeWorkoutControllerProvider).logSet(
          sessionId: widget.sessionId,
          exerciseId: widget.exercise.id,
          setNumber: widget.nextSetNumber,
          weight: toCanonicalKg(enteredWeight, unit),
          reps: int.parse(_repsController.text),
          rpe: rpeText.isEmpty ? null : double.tryParse(rpeText.replaceAll(',', '.')),
          isWarmup: _isWarmup,
          notes: notesText.isEmpty ? null : notesText,
        );
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final unit = ref.watch(preferredWeightUnitProvider);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).padding.bottom +
            16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.exercise.name, style: Theme.of(context).textTheme.titleLarge),
            Text(l10n.setNumberLabel(widget.nextSetNumber), style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _weightController,
                    autofocus: true,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(labelText: l10n.weightLabelWithUnit(unitLabel(unit))),
                    validator: (value) =>
                        double.tryParse((value ?? '').replaceAll(',', '.')) == null ? l10n.invalid : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _repsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: l10n.repsLabel),
                    validator: (value) => int.tryParse(value ?? '') == null ? l10n.invalid : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _rpeController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l10n.rpeOptionalLabel),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return null;
                final parsed = double.tryParse(value.replaceAll(',', '.'));
                if (parsed == null || parsed < 1 || parsed > 10) return l10n.rpeRangeError;
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(labelText: l10n.noteOptionalLabel),
              maxLines: 2,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.warmupSetLabel),
              value: _isWarmup,
              onChanged: (value) => setState(() => _isWarmup = value),
            ),
            const SizedBox(height: 8),
            FilledButton(onPressed: _submit, child: Text(l10n.logSetButton)),
          ],
        ),
      ),
    );
  }
}
