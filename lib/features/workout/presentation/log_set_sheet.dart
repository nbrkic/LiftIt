import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/app_database.dart';
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
  bool _isWarmup = false;

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(activeWorkoutControllerProvider).logSet(
          sessionId: widget.sessionId,
          exerciseId: widget.exercise.id,
          setNumber: widget.nextSetNumber,
          weight: double.parse(_weightController.text.replaceAll(',', '.')),
          reps: int.parse(_repsController.text),
          isWarmup: _isWarmup,
        );
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
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
                    decoration: const InputDecoration(labelText: 'Weight (kg)'),
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
