import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../common/weight_format.dart';
import '../../../database/queries/workout_queries.dart';
import '../../../l10n/app_localizations.dart';
import '../../profile/providers/profile_providers.dart';
import '../../splits/providers/split_providers.dart';
import '../providers/history_providers.dart';

class SessionDetailScreen extends ConsumerWidget {
  final int sessionId;

  const SessionDetailScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        top: false,
        child: setsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text(l10n.errorMessage('$error'))),
          data: (sets) {
            if (sets.isEmpty) {
              return Center(child: Text(l10n.noSetsLogged));
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
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        if (session != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              _formatFullDate(context, session.startedAt),
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _SummaryStat(
                              icon: Icons.timer_outlined,
                              value: duration != null ? '${duration.inMinutes}' : '-',
                              label: l10n.minutesLabel,
                            ),
                            _SummaryStat(
                              icon: Icons.fitness_center,
                              value: formatWeight(volume, unit, decimals: 0),
                              label: l10n.volumeLabel,
                            ),
                            _SummaryStat(
                              icon: Icons.list_alt,
                              value: '$exerciseCount',
                              label: exerciseCount == 1 ? l10n.exerciseLabelSingular : l10n.exerciseLabelPlural,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ...groupOrder.map((exerciseId) {
                  final entries = groups[exerciseId]!;
                  final exercise = entries.first.exercise;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(exercise.name, style: theme.textTheme.titleMedium),
                          const SizedBox(height: 4),
                          ...entries.map((entry) {
                            final set = entry.set;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 28,
                                    child: Text(
                                      '${set.setNumber}',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.timesReps(formatWeight(set.weight, unit), set.reps) +
                                              (set.rpe != null ? '  •  RPE ${set.rpe}' : '') +
                                              (set.isWarmup ? '  •  ${l10n.warmupSetLabel}' : ''),
                                        ),
                                        if (set.notes != null && set.notes!.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 2),
                                            child: Text(
                                              set.notes!,
                                              style: theme.textTheme.bodySmall?.copyWith(
                                                fontStyle: FontStyle.italic,
                                                color: theme.colorScheme.onSurfaceVariant,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(height: 4),
                        ],
                      ),
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

class _SummaryStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _SummaryStat({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.titleMedium),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
