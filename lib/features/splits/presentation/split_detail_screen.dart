import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/empty_state.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/split_providers.dart';
import 'add_split_day_sheet.dart';

class SplitDetailScreen extends ConsumerWidget {
  final int splitId;

  const SplitDetailScreen({super.key, required this.splitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final splitAsync = ref.watch(splitByIdProvider(splitId));
    final daysAsync = ref.watch(splitDaysProvider(splitId));
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(splitAsync.value?.name ?? l10n.splitFallbackTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => AddSplitDaySheet(splitId: splitId),
        ),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        top: false,
        child: daysAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text(l10n.errorMessage('$error'))),
          data: (days) {
            if (days.isEmpty) {
              return LiftEmptyState(message: l10n.noDaysYetTapToAdd);
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.sm),
              itemCount: days.length,
              separatorBuilder: (_, _) => Divider(height: 1, color: c.divider),
              itemBuilder: (context, index) {
                final day = days[index];
                return Dismissible(
                  key: ValueKey(day.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: c.danger.withValues(alpha: 0.15),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: AppSpacing.lg),
                    child: Icon(Icons.delete_outline, color: c.danger),
                  ),
                  onDismissed: (_) =>
                      ref.read(splitControllerProvider).deleteDay(day.id),
                  child: InkWell(
                    onTap: () => context.push('/splits/$splitId/day/${day.id}'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(day.name, style: Theme.of(context).textTheme.titleMedium),
                          ),
                          Icon(Icons.chevron_right, size: 20, color: c.textSecondary),
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
