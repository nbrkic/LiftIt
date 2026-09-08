import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/split_providers.dart';

class CreateSplitSheet extends ConsumerStatefulWidget {
  const CreateSplitSheet({super.key});

  @override
  ConsumerState<CreateSplitSheet> createState() => _CreateSplitSheetState();
}

class _CreateSplitSheetState extends ConsumerState<CreateSplitSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final id = await ref.read(splitControllerProvider).createSplit(
          name: _nameController.text.trim(),
          description:
              _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        );
    if (mounted) Navigator.of(context).pop(id);
  }

  @override
  Widget build(BuildContext context) {
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
            Text(l10n.createSplitTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              autofocus: true,
              decoration: InputDecoration(labelText: l10n.splitNameLabel),
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? l10n.enterAName : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: l10n.descriptionOptionalLabel),
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: _submit, child: Text(l10n.createButton)),
          ],
        ),
      ),
    );
  }
}
