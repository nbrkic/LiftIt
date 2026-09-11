import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/enums.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/empty_state.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/api_search_providers.dart';
import '../services/food_search_result.dart';
import 'confirm_food_sheet.dart';
import 'describe_food_flow.dart';

class FoodSearchScreen extends ConsumerStatefulWidget {
  final DateTime day;

  const FoodSearchScreen({super.key, required this.day});

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
      builder: (_) => ConfirmFoodSheet(searchResult: result, day: widget.day),
    );
    if (logged == true && mounted) Navigator.of(context).pop();
  }

  Future<void> _tryAiEstimate() async {
    await showDescribeFoodFlow(context, ref, initialDescription: _submittedQuery, day: widget.day);
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
