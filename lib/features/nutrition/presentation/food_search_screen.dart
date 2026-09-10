import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../database/enums.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/empty_state.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/api_keys_provider.dart';
import '../providers/api_search_providers.dart';
import '../services/food_search_result.dart';
import '../services/gemini_service.dart';
import 'confirm_food_sheet.dart';

class FoodSearchScreen extends ConsumerStatefulWidget {
  const FoodSearchScreen({super.key});

  @override
  ConsumerState<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends ConsumerState<FoodSearchScreen> {
  final _controller = TextEditingController();
  String? _submittedQuery;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final query = _controller.text.trim();
    if (query.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() => _submittedQuery = query);
  }

  Future<void> _pickResult(FoodSearchResult result) async {
    final logged = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ConfirmFoodSheet(searchResult: result),
    );
    if (logged == true && mounted) Navigator.of(context).pop();
  }

  Future<void> _tryAiEstimate() async {
    final l10n = AppLocalizations.of(context)!;
    final apiKey = (await ref.read(apiKeysProvider.notifier).ensureGeminiApiKey()).trim();
    if (!mounted) return;
    if (apiKey.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.nutritionGeminiKeyMissing)));
      return;
    }

    final descController = TextEditingController(text: _submittedQuery ?? '');
    final description = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.nutritionDescribeFoodTitle),
        content: TextField(
          controller: descController,
          autofocus: true,
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
    if (description == null || description.isEmpty || !mounted) return;

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
      if (!mounted) return;
      Navigator.of(context).pop(); // dismiss the processing dialog
      if (items.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.nutritionNoItemsRecognized)));
        return;
      }
      context.push('/nutrition/photo-results', extra: items);
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // dismiss the processing dialog
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.errorMessage('$e'))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final resultsAsync =
        _submittedQuery == null ? null : ref.watch(foodSearchResultsProvider(_submittedQuery!));
    final usdaKeyMissing = ref.watch(usdaKeyMissingProvider);

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: AppSpacing.md),
          child: TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: l10n.nutritionSearchFoodHint,
              isDense: true,
              prefixIcon: const Icon(Icons.search, size: 20),
            ),
            onSubmitted: (_) => _submit(),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            if (usdaKeyMissing)
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.md, AppSpacing.xxl, 0),
                child: Text(
                  l10n.nutritionUsdaKeyMissingHint,
                  style: theme.textTheme.bodySmall?.copyWith(color: c.textSecondary),
                ),
              ),
            Expanded(
              child: resultsAsync == null
                  ? const SizedBox.shrink()
                  : resultsAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Center(child: Text(l10n.errorMessage('$error'))),
                      data: (results) {
                        if (results.isEmpty) {
                          return LiftEmptyState(
                            message: l10n.nutritionSearchEmptyResults,
                            actionLabel: l10n.nutritionTryAiEstimateAction,
                            onAction: _tryAiEstimate,
                          );
                        }
                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xxl, vertical: AppSpacing.sm),
                          itemCount: results.length,
                          separatorBuilder: (_, _) => Divider(height: 1, color: c.divider),
                          itemBuilder: (context, index) {
                            final result = results[index];
                            return InkWell(
                              onTap: () => _pickResult(result),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(result.name, style: theme.textTheme.bodyLarge),
                                          const SizedBox(height: 2),
                                          Text(
                                            [
                                              if (result.brand != null && result.brand!.isNotEmpty)
                                                result.brand!,
                                              result.source.label(context),
                                            ].join(' • '),
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(color: c.textSecondary),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${result.caloriesPer100g.round()}',
                                      style: theme.textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
