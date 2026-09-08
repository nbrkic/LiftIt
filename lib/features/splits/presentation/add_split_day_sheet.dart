import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/split_providers.dart';

class AddSplitDaySheet extends ConsumerStatefulWidget {
  final int splitId;

  const AddSplitDaySheet({super.key, required this.splitId});

  @override
  ConsumerState<AddSplitDaySheet> createState() => _AddSplitDaySheetState();
}

class _AddSplitDaySheetState extends ConsumerState<AddSplitDaySheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(splitControllerProvider).addDay(
          splitId: widget.splitId,
          name: _nameController.text.trim(),
        );
    if (mounted) Navigator.of(context).pop();
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
            Text(l10n.addDayTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              autofocus: true,
              decoration: InputDecoration(labelText: l10n.dayNameLabel),
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? l10n.enterAName : null,
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: _submit, child: Text(l10n.addDayButton)),
          ],
        ),
      ),
    );
  }
}
