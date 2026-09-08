import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/app_database.dart';
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
            const SizedBox(height: 16),
            TextFormField(
              controller: _setsController,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Target sets'),
              validator: (value) => int.tryParse(value ?? '') == null ? 'Invalid' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _repsLowController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Reps from (optional)'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _repsHighController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Reps to (optional)'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: _submit, child: const Text('Add to Day')),
          ],
        ),
      ),
    );
  }
}
