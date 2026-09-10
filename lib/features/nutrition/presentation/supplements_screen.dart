import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/empty_state.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/supplement_providers.dart';
import 'add_supplement_sheet.dart';

class SupplementsScreen extends ConsumerWidget {
  const SupplementsScreen({super.key});

  Future<bool> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteSupplementDialogTitle),
        content: Text(l10n.deleteSupplementDialogContent),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final supplementsAsync = ref.watch(supplementsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.nutritionSupplementsLabel)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => const AddSupplementSheet(),
        ),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        top: false,
        child: supplementsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text(l10n.errorMessage('$error'))),
          data: (supplements) {
            if (supplements.isEmpty) {
              return LiftEmptyState(message: l10n.nutritionSupplementsEmpty);
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.sm),
              itemCount: supplements.length,
              separatorBuilder: (_, _) => Divider(height: 1, color: c.divider),
              itemBuilder: (context, index) {
                final supplement = supplements[index];
                return Dismissible(
                  key: ValueKey(supplement.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) => _confirmDelete(context),
                  onDismissed: (_) =>
                      ref.read(supplementControllerProvider).deleteSupplement(supplement.id),
                  background: Container(
                    color: c.danger.withValues(alpha: 0.15),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: AppSpacing.lg),
                    child: Icon(Icons.delete_outline, color: c.danger),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: Text(
                      '${supplement.name} ${supplement.dosageLabel}',
                      style: theme.textTheme.bodyLarge,
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
