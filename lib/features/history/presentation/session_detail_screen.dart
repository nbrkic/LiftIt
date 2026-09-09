import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../common/weight_format.dart';
import '../../../database/queries/workout_queries.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/empty_state.dart';
import '../../../design/widgets/set_row.dart';
import '../../../design/widgets/stat_block.dart';
import '../../../l10n/app_localizations.dart';
import '../../profile/providers/profile_providers.dart';
import '../../splits/providers/split_providers.dart';
import '../providers/history_providers.dart';

class SessionDetailScreen extends ConsumerWidget {
  final int sessionId;

  const SessionDetailScreen({super.key, required this.sessionId});

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteWorkoutDialogTitle),
        content: Text(l10n.deleteWorkoutDialogContent),
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
    if (confirmed != true || !context.mounted) return;
    await ref.read(historyControllerProvider).deleteSession(sessionId);
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final sessionAsync = ref.watch(sessionByIdProvider(sessionId));
    final setsAsync = ref.watch(sessionDetailProvider(sessionId));
    final unit = ref.watch(preferredWeightUnitProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final session = sessionAsync.value;
    final splitDayAsync = session?.splitDayId != null
        ? ref.watch(splitDayByIdProvider(session!.splitDayId!))
        : null;
    final title = splitDayAsync?.value?.name ?? l10n.freestyle;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _delete(context, ref),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: setsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text(l10n.errorMessage('$error'))),
          data: (sets) {
            if (sets.isEmpty) {
              return LiftEmptyState(message: l10n.noSetsLogged);
            }

            final working = sets.where((e) => !e.set.isWarmup);
            final volume = working.fold(0.0, (sum, e) => sum + e.set.weight * e.set.reps);
            final exerciseCount = sets.map((e) => e.exercise.id).toSet().length;
            final duration = session?.endedAt != null
                ? session!.endedAt!.difference(session.startedAt)
                : null;

            final groupOrder = <int>[];
            final groups = <int, List<WorkoutSetWithExercise>>{};
            for (final entry in sets) {
              groups.putIfAbsent(entry.exercise.id, () {
                groupOrder.add(entry.exercise.id);
                return [];
              }).add(entry);
            }

            return ListView(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              children: [
                if (session != null)
                  Text(
                    _formatFullDate(context, session.startedAt),
                    style: theme.textTheme.bodyMedium?.copyWith(color: c.textSecondary),
                  ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    StatBlock(
                      value: duration != null ? '${duration.inMinutes}' : '-',
                      label: l10n.minutesLabel,
                    ),
                    const SizedBox(width: AppSpacing.xxxl),
                    StatBlock(
                      value: formatWeight(volume, unit, decimals: 0),
                      label: l10n.volumeLabel,
                    ),
                    const SizedBox(width: AppSpacing.xxxl),
                    StatBlock(
                      value: '$exerciseCount',
                      label: exerciseCount == 1 ? l10n.exerciseLabelSingular : l10n.exerciseLabelPlural,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxxl),
                ...groupOrder.map((exerciseId) {
                  final entries = groups[exerciseId]!;
                  final exercise = entries.first.exercise;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(exercise.name, style: theme.textTheme.titleMedium),
                        Divider(height: AppSpacing.md, color: c.divider),
                        ...entries.map((entry) => SetRow(
                              setNumber: entry.set.setNumber,
                              weightLabel: formatWeight(entry.set.weight, unit),
                              reps: entry.set.reps,
                              rpe: entry.set.rpe,
                              note: entry.set.notes,
                              isWarmup: entry.set.isWarmup,
                            )),
                      ],
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  String _formatFullDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).toString();
    final weekday = DateFormat.EEEE(locale).format(date);
    final month = DateFormat.MMMM(locale).format(date);
    return '$weekday, ${date.day} $month';
  }
}
