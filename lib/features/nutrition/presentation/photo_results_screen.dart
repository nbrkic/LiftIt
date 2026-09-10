import 'package:flutter/material.dart';
import '../../../database/enums.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../services/food_search_result.dart';
import 'confirm_food_sheet.dart';

// Shown after either photo recognition or the free-text AI fallback —
// both produce the same List<GeminiFoodItem> shape, so one screen serves
// both entry paths. Tap an item to review/adjust it in the Confirm sheet
// before logging (bulk "log all" is left for later polish).
class PhotoResultsScreen extends StatelessWidget {
  final List<GeminiFoodItem> items;

  const PhotoResultsScreen({super.key, required this.items});

  Future<void> _confirm(BuildContext context, GeminiFoodItem item) async {
    final logged = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ConfirmFoodSheet(
        initialName: item.name,
        initialQuantityLabel: item.quantityLabel,
        initialCalories: item.calories,
        initialProteinG: item.proteinG,
        initialCarbsG: item.carbsG,
        initialFatG: item.fatG,
        source: FoodLogSource.gemini,
      ),
    );
    if (logged == true && context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.nutritionPhotoResultsTitle)),
      body: SafeArea(
        top: false,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.sm),
          itemCount: items.length,
          separatorBuilder: (_, _) => Divider(height: 1, color: c.divider),
          itemBuilder: (context, index) {
            final item = items[index];
            return InkWell(
              onTap: () => _confirm(context, item),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, style: theme.textTheme.bodyLarge),
                          const SizedBox(height: 2),
                          Text(
                            item.quantityLabel,
                            style: theme.textTheme.bodySmall?.copyWith(color: c.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Text('${item.calories.round()}', style: theme.textTheme.titleMedium),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
