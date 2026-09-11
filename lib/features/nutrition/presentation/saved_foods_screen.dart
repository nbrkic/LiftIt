import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/app_database.dart';
import '../../../database/enums.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/empty_state.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/saved_foods_providers.dart';
import '../services/food_search_result.dart';
import 'confirm_food_sheet.dart';

class SavedFoodsScreen extends ConsumerWidget {
  final DateTime day;

  const SavedFoodsScreen({super.key, required this.day});

  Future<bool> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteSavedFoodDialogTitle),
        content: Text(l10n.deleteSavedFoodDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.deleteButton),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  Future<void> _pickSavedFood(BuildContext context, SavedFood food) async {
    final logged = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => food.isPer100g
          ? ConfirmFoodSheet(
              searchResult: FoodSearchResult(
                name: food.name,
                brand: food.brand,
                caloriesPer100g: food.calories,
                proteinPer100g: food.proteinG,
                carbsPer100g: food.carbsG,
                fatPer100g: food.fatG,
                source: FoodLogSource.manual,
              ),
              day: day,
            )
          : ConfirmFoodSheet(
              initialName: food.name,
              initialQuantityLabel: food.quantityLabel,
              initialCalories: food.calories,
              initialProteinG: food.proteinG,
              initialCarbsG: food.carbsG,
              initialFatG: food.fatG,
              day: day,
            ),
    );
    if (logged == true && context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final foodsAsync = ref.watch(savedFoodsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.nutritionSavedFoodTitle)),
      body: SafeArea(
        top: false,
        child: foodsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text(l10n.errorMessage('$error'))),
          data: (foods) {
            if (foods.isEmpty) {
              return LiftEmptyState(message: l10n.nutritionSavedFoodEmpty);
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.sm),
              itemCount: foods.length,
              separatorBuilder: (_, _) => Divider(height: 1, color: c.divider),
              itemBuilder: (context, index) {
                final food = foods[index];
                return Dismissible(
                  key: ValueKey(food.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) => _confirmDelete(context),
                  onDismissed: (_) =>
                      ref.read(savedFoodsControllerProvider).deleteFood(food.id),
                  background: Container(
                    color: c.danger.withValues(alpha: 0.15),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: AppSpacing.lg),
                    child: Icon(Icons.delete_outline, color: c.danger),
                  ),
                  child: InkWell(
                    onTap: () => _pickSavedFood(context, food),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(food.name, style: theme.textTheme.bodyLarge),
                                const SizedBox(height: 2),
                                Text(
                                  [
                                    if (food.brand != null && food.brand!.isNotEmpty) food.brand!,
                                    food.isPer100g
                                        ? l10n.nutritionPer100gBadge
                                        : food.quantityLabel,
                                  ].join(' • '),
                                  style: theme.textTheme.bodySmall?.copyWith(color: c.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          Text('${food.calories.round()}', style: theme.textTheme.titleMedium),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
