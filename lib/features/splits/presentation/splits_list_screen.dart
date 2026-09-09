import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/empty_state.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/split_providers.dart';
import 'create_split_sheet.dart';

class SplitsListScreen extends ConsumerWidget {
  const SplitsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final splitsAsync = ref.watch(splitListProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.splitsTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final id = await showModalBottomSheet<int>(
            context: context,
            isScrollControlled: true,
            builder: (_) => const CreateSplitSheet(),
          );
          if (id != null && context.mounted) context.push('/splits/$id');
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        top: false,
        child: splitsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text(l10n.errorMessage('$error'))),
          data: (splitList) {
            if (splitList.isEmpty) {
              return LiftEmptyState(message: l10n.noSplitsYetTapToCreate);
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.sm),
              itemCount: splitList.length,
              separatorBuilder: (_, _) => Divider(height: 1, color: c.divider),
              itemBuilder: (context, index) {
                final split = splitList[index];
                return Dismissible(
                  key: ValueKey(split.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: c.danger.withValues(alpha: 0.15),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: AppSpacing.lg),
                    child: Icon(Icons.delete_outline, color: c.danger),
                  ),
                  onDismissed: (_) =>
                      ref.read(splitControllerProvider).deleteSplit(split.id),
                  child: InkWell(
                    onTap: () => context.push('/splits/${split.id}'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(split.name, style: Theme.of(context).textTheme.titleMedium),
                                if (split.description != null && split.description!.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    split.description!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: c.textSecondary),
                                  ),
                                ],
                              ],
                            ),
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
