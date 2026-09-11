import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/weight_format.dart';
import '../../../database/app_database.dart';
import '../../../database/enums.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/tokens/app_typography.dart';
import '../../../design/widgets/lift_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../exercises/providers/exercise_stats_providers.dart';
import '../../exercises/utils/exercise_stats.dart';
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
  bool _showAdvanced = false;

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
    final id = await ref.read(activeWorkoutControllerProvider).logSet(
          sessionId: widget.sessionId,
          exerciseId: widget.exercise.id,
          setNumber: widget.nextSetNumber,
          weight: toCanonicalKg(enteredWeight, unit),
          reps: int.parse(_repsController.text),
          rpe: rpeText.isEmpty ? null : double.tryParse(rpeText.replaceAll(',', '.')),
          isWarmup: _isWarmup,
          notes: notesText.isEmpty ? null : notesText,
        );
    if (mounted) Navigator.of(context).pop(id);
  }

  void _applySuggestion(NextSetSuggestion suggestion, WeightUnit unit) {
    final displayVal = displayWeight(suggestion.weight, unit);
    setState(() {
      _weightController.text =
          displayVal % 1 == 0 ? displayVal.toInt().toString() : displayVal.toStringAsFixed(1);
      _repsController.text = '${suggestion.reps}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final unit = ref.watch(preferredWeightUnitProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final historyAsync = ref.watch(exerciseSetsProvider(widget.exercise.id));
    final previous = historyAsync.value != null
        ? previousSessionSets(historyAsync.value!, widget.sessionId)
        : const <WorkoutSet>[];
    final suggestion = historyAsync.value != null
        ? suggestNextSet(
            historyAsync.value!,
            widget.sessionId,
            weightIncrementKg: unit == WeightUnit.kg ? 2.5 : lbToKg(5),
          )
        : null;

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
            Text(widget.exercise.name, style: theme.textTheme.titleLarge),
            const SizedBox(height: 2),
            Text(l10n.setNumberLabel(widget.nextSetNumber), style: theme.textTheme.bodySmall),
            if (previous.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${l10n.lastTimeLabel}: ${previous.map((s) => '${formatWeight(s.weight, unit)}×${s.reps}').join(', ')}',
                style: theme.textTheme.bodySmall?.copyWith(color: c.violetLight),
              ),
            ],
            if (suggestion != null) ...[
              const SizedBox(height: AppSpacing.xs),
              InkWell(
                onTap: () => _applySuggestion(suggestion, unit),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt, size: 14, color: c.violet),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '${l10n.suggestedNextSetLabel}: ${formatWeight(suggestion.weight, unit)}×${suggestion.reps}',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: c.violet, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _weightController,
                    autofocus: true,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: AppTypography.numeral(size: 28, color: c.textPrimary),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(labelText: l10n.weightLabelWithUnit(unitLabel(unit))),
                    validator: (value) =>
                        double.tryParse((value ?? '').replaceAll(',', '.')) == null ? l10n.invalid : null,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextFormField(
                    controller: _repsController,
                    keyboardType: TextInputType.number,
                    style: AppTypography.numeral(size: 28, color: c.textPrimary),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(labelText: l10n.repsLabel),
                    validator: (value) => int.tryParse(value ?? '') == null ? l10n.invalid : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            InkWell(
              onTap: () => setState(() => _showAdvanced = !_showAdvanced),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Row(
                  children: [
                    Icon(
                      _showAdvanced ? Icons.expand_less : Icons.expand_more,
                      size: 18,
                      color: c.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text('RPE · ${l10n.noteOptionalLabel} · ${l10n.warmupSetLabel}',
                        style: theme.textTheme.labelMedium),
                  ],
                ),
              ),
            ),
            if (_showAdvanced) ...[
              const SizedBox(height: AppSpacing.sm),
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
              const SizedBox(height: AppSpacing.md),
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
              const SizedBox(height: AppSpacing.sm),
            ],
            const SizedBox(height: AppSpacing.md),
            LiftPrimaryButton(label: l10n.logSetButton, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
