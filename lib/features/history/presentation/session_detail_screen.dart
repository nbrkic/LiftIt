import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../common/weight_format.dart';
import '../../../database/queries/workout_queries.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/empty_state.dart';
import '../../../design/widgets/set_row.dart';
import '../../../design/widgets/stat_block.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/api_keys_provider.dart';
import '../../exercises/providers/exercise_stats_providers.dart';
import '../../exercises/utils/exercise_stats.dart';
import '../../profile/providers/profile_providers.dart';
import '../../splits/providers/split_providers.dart';
import '../../workout/providers/active_workout_providers.dart';
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
                if (session?.aiSummary != null) ...[
                  const SizedBox(height: AppSpacing.xxxl),
                  Container(
                    padding: const EdgeInsets.only(left: AppSpacing.md),
                    decoration: BoxDecoration(
                      border: Border(left: BorderSide(color: c.violet, width: 3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.aiWorkoutSummaryLabel.toUpperCase(),
                          style: theme.textTheme.labelMedium?.copyWith(color: c.textSecondary),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(session!.aiSummary!, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ] else if (session != null) ...[
                  const SizedBox(height: AppSpacing.xxxl),
                  _GenerateCoachNotesButton(sessionId: sessionId, sets: sets),
                ],
                const SizedBox(height: AppSpacing.xxxl),
                ...groupOrder.map((exerciseId) {
                  final entries = groups[exerciseId]!;
                  final exercise = entries.first.exercise;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => context.push('/exercises/$exerciseId'),
                          child: Text(exercise.name, style: theme.textTheme.titleMedium),
                        ),
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

// Covers both a failed/never-attempted background generation (e.g. Gemini
// was down right after this workout finished) and sessions logged before
// this feature existed — either way, `aiSummary` is just null, so this
// button lets the user ask for it explicitly instead of it staying
// permanently blank.
class _GenerateCoachNotesButton extends ConsumerStatefulWidget {
  final int sessionId;
  final List<WorkoutSetWithExercise> sets;

  const _GenerateCoachNotesButton({required this.sessionId, required this.sets});

  @override
  ConsumerState<_GenerateCoachNotesButton> createState() => _GenerateCoachNotesButtonState();
}

class _GenerateCoachNotesButtonState extends ConsumerState<_GenerateCoachNotesButton> {
  bool _generating = false;

  Future<void> _generate() async {
    setState(() => _generating = true);
    final l10n = AppLocalizations.of(context)!;
    final apiKey = (await ref.read(apiKeysProvider.notifier).ensureGeminiApiKey()).trim();
    if (!mounted) return;
    if (apiKey.isEmpty) {
      setState(() => _generating = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.nutritionGeminiKeyMissing)));
      return;
    }

    final setsByExercise = <int, List<WorkoutSetWithExercise>>{};
    for (final entry in widget.sets) {
      setsByExercise.putIfAbsent(entry.exercise.id, () => []).add(entry);
    }
    final hasPr = setsByExercise.keys.any((exerciseId) {
      final allSets = ref.read(exerciseSetsProvider(exerciseId)).value;
      final best = allSets != null ? computeOneRepMax(allSets) : null;
      if (best == null) return false;
      final sessionSetIds = setsByExercise[exerciseId]!.map((e) => e.set.id).toSet();
      return sessionSetIds.contains(best.set.id);
    });

    final languageName = Localizations.localeOf(context).languageCode == 'sr' ? 'Serbian' : 'English';
    final succeeded = await ref.read(activeWorkoutControllerProvider).generateAiSummary(
          sessionId: widget.sessionId,
          apiKey: apiKey,
          languageName: languageName,
          hasPr: hasPr,
        );
    if (!mounted) return;
    setState(() => _generating = false);
    if (!succeeded) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.generateCoachNotesFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context)!;
    if (_generating) {
      return Row(
        children: [
          const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
          const SizedBox(width: AppSpacing.md),
          Text(l10n.aiWorkoutSummaryGenerating,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: c.textSecondary)),
        ],
      );
    }
    return OutlinedButton.icon(
      onPressed: _generate,
      icon: const Icon(Icons.auto_awesome_outlined, size: 18),
      label: Text(l10n.generateCoachNotesAction),
    );
  }
}
