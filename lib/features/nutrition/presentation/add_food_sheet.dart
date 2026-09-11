import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import 'confirm_food_sheet.dart';

// The entry point for logging food — grows a new option per stage (search
// now, barcode/photo once their stages land) without ever blocking manual
// entry, since every external source can independently fail.
class AddFoodSheet extends StatelessWidget {
  final DateTime selectedDay;

  const AddFoodSheet({super.key, required this.selectedDay});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.nutritionAddFoodTitle, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.lg),
          _AddFoodOption(
            icon: Icons.qr_code_scanner,
            label: l10n.nutritionScanBarcodeOption,
            onTap: () {
              Navigator.of(context).pop();
              context.push('/nutrition/scan', extra: selectedDay);
            },
          ),
          Divider(height: 1, color: c.divider),
          _AddFoodOption(
            icon: Icons.search,
            label: l10n.nutritionSearchOption,
            onTap: () {
              Navigator.of(context).pop();
              context.push('/nutrition/search', extra: selectedDay);
            },
          ),
          Divider(height: 1, color: c.divider),
          _AddFoodOption(
            icon: Icons.camera_alt_outlined,
            label: l10n.nutritionPhotoOption,
            onTap: () => Navigator.of(context).pop('photo'),
          ),
          Divider(height: 1, color: c.divider),
          _AddFoodOption(
            icon: Icons.notes_outlined,
            label: l10n.nutritionDescribeOption,
            onTap: () => Navigator.of(context).pop('describe'),
          ),
          Divider(height: 1, color: c.divider),
          _AddFoodOption(
            icon: Icons.edit_outlined,
            label: l10n.nutritionManualOption,
            onTap: () {
              Navigator.of(context).pop();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => ConfirmFoodSheet(day: selectedDay),
              );
            },
          ),
          Divider(height: 1, color: c.divider),
          _AddFoodOption(
            icon: Icons.bookmark_outline,
            label: l10n.nutritionLoadValuesOption,
            onTap: () {
              Navigator.of(context).pop();
              context.push('/nutrition/saved', extra: selectedDay);
            },
          ),
        ],
      ),
    );
  }
}

class _AddFoodOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AddFoodOption({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            Icon(icon, size: 22, color: c.violet),
            const SizedBox(width: AppSpacing.lg),
            Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
