import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/lift_button.dart';
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
            Text(l10n.addDayTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xl),
            TextFormField(
              controller: _nameController,
              autofocus: true,
              decoration: InputDecoration(labelText: l10n.dayNameLabel),
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? l10n.enterAName : null,
            ),
            const SizedBox(height: AppSpacing.xl),
            LiftPrimaryButton(label: l10n.addDayButton, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
