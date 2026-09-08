import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/weight_format.dart';
import '../../../database/app_database.dart';
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
  bool _isWarmup = false;

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    _rpeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final unit = ref.read(preferredWeightUnitProvider);
    final enteredWeight = double.parse(_weightController.text.replaceAll(',', '.'));
    final rpeText = _rpeController.text.trim();
    await ref.read(activeWorkoutControllerProvider).logSet(
          sessionId: widget.sessionId,
          exerciseId: widget.exercise.id,
          setNumber: widget.nextSetNumber,
          weight: toCanonicalKg(enteredWeight, unit),
          reps: int.parse(_repsController.text),
          rpe: rpeText.isEmpty ? null : double.tryParse(rpeText.replaceAll(',', '.')),
          isWarmup: _isWarmup,
        );
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final unit = ref.watch(preferredWeightUnitProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.exercise.name, style: Theme.of(context).textTheme.titleLarge),
            Text('Set ${widget.nextSetNumber}', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _weightController,
                    autofocus: true,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(labelText: 'Weight (${unitLabel(unit)})'),
                    validator: (value) =>
                        double.tryParse((value ?? '').replaceAll(',', '.')) == null ? 'Invalid' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _repsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Reps'),
                    validator: (value) => int.tryParse(value ?? '') == null ? 'Invalid' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _rpeController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'RPE (optional, 1-10)'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return null;
                final parsed = double.tryParse(value.replaceAll(',', '.'));
                if (parsed == null || parsed < 1 || parsed > 10) return '1-10';
                return null;
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Warm-up set'),
              value: _isWarmup,
              onChanged: (value) => setState(() => _isWarmup = value),
            ),
            const SizedBox(height: 8),
            FilledButton(onPressed: _submit, child: const Text('Log Set')),
          ],
        ),
      ),
    );
  }
}
