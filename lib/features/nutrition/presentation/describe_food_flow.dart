import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/api_keys_provider.dart';
import '../services/gemini_service.dart';

// Shared by the "Describe Food" add-food option and the search screen's
// empty-results fallback — both just ask for a free-text description (what,
// how much, how it was prepared) and hand it to Gemini for a calorie/macro
// estimate, landing on the same photo-results-style review list.
Future<void> showDescribeFoodFlow(
  BuildContext context,
  WidgetRef ref, {
  required DateTime day,
  String? initialDescription,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final apiKey = (await ref.read(apiKeysProvider.notifier).ensureGeminiApiKey()).trim();
  if (!context.mounted) return;
  if (apiKey.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.nutritionGeminiKeyMissing)));
    return;
  }

  final descController = TextEditingController(text: initialDescription ?? '');
  final description = await showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.nutritionDescribeFoodTitle),
      content: TextField(
        controller: descController,
        autofocus: true,
        maxLines: 3,
        decoration: InputDecoration(hintText: l10n.nutritionDescribeFoodHint),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(l10n.cancelButton),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(descController.text.trim()),
          child: Text(l10n.nutritionEstimateButton),
        ),
      ],
    ),
  );
  if (description == null || description.isEmpty || !context.mounted) return;

  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(width: AppSpacing.lg),
          Expanded(child: Text(l10n.nutritionAiProcessing)),
        ],
      ),
    ),
  );

  try {
    final items = await GeminiService().estimateFromDescription(description, apiKey);
    if (!context.mounted) return;
    Navigator.of(context).pop(); // dismiss the processing dialog
    if (items.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.nutritionNoItemsRecognized)));
      return;
    }
    context.push('/nutrition/photo-results', extra: (items: items, day: day));
  } catch (e) {
    if (!context.mounted) return;
    Navigator.of(context).pop(); // dismiss the processing dialog
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.errorMessage('$e'))));
  }
}
