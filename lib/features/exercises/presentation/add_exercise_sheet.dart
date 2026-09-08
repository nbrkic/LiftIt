import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/enums.dart';
import '../providers/exercise_providers.dart';

class AddExerciseSheet extends ConsumerStatefulWidget {
  const AddExerciseSheet({super.key});

  @override
  ConsumerState<AddExerciseSheet> createState() => _AddExerciseSheetState();
}

class _AddExerciseSheetState extends ConsumerState<AddExerciseSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  MuscleGroup _muscleGroup = MuscleGroup.chest;
  Equipment _equipment = Equipment.barbell;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(addCustomExerciseProvider)(
      name: _nameController.text.trim(),
      muscleGroup: _muscleGroup,
      equipment: _equipment,
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
            Text('Add Custom Exercise', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Enter a name' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<MuscleGroup>(
              initialValue: _muscleGroup,
              decoration: const InputDecoration(labelText: 'Muscle group'),
              items: MuscleGroup.values
                  .map((m) => DropdownMenuItem(value: m, child: Text(m.label)))
                  .toList(),
              onChanged: (value) => setState(() => _muscleGroup = value!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Equipment>(
              initialValue: _equipment,
              decoration: const InputDecoration(labelText: 'Equipment'),
              items: Equipment.values
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.label)))
                  .toList(),
              onChanged: (value) => setState(() => _equipment = value!),
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: _submit, child: const Text('Add Exercise')),
          ],
        ),
      ),
    );
  }
}
