import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    await ref.read(profileControllerProvider).logBodyweight(
          weightKg: double.parse(_weightController.text.replaceAll(',', '.')),
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
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
            Text('Log Weigh-in', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: _weightController,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
              validator: (value) =>
                  double.tryParse((value ?? '').replaceAll(',', '.')) == null ? 'Invalid' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes (optional)'),
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: _submit, child: const Text('Log Weight')),
          ],
        ),
      ),
    );
  }
}
