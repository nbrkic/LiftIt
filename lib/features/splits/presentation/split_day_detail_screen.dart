import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../database/app_database.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/empty_state.dart';
import '../../../design/widgets/lift_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../workout/presentation/exercise_picker_sheet.dart';
import '../providers/split_providers.dart';
import 'target_sets_reps_sheet.dart';

class SplitDayDetailScreen extends ConsumerWidget {
  final int splitDayId;

  const SplitDayDetailScreen({super.key, required this.splitDayId});

  Future<void> _addExercise(BuildContext context, WidgetRef ref) async {
    final exercise = await showModalBottomSheet<Exercise>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const ExercisePickerSheet(),
    );
    if (exercise == null || !context.mounted) return;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          TargetSetsRepsSheet(exercise: exercise, splitDayId: splitDayId),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final dayAsync = ref.watch(splitDayByIdProvider(splitDayId));
    final plannedAsync = ref.watch(splitDayExercisesProvider(splitDayId));
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(dayAsync.value?.name ?? l10n.dayFallbackTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addExercise(context, ref),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        top: false,
        child: plannedAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text(l10n.errorMessage('$error'))),
          data: (planned) {
            return Column(
              children: [
                Expanded(
                  child: planned.isEmpty
                      ? LiftEmptyState(message: l10n.noExercisesYetTapToAdd)
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xxl, vertical: AppSpacing.sm),
                          itemCount: planned.length,
                          separatorBuilder: (_, _) => Divider(height: 1, color: c.divider),
                          itemBuilder: (context, index) {
                            final entry = planned[index];
                            final repsRange =
                                entry.planned.targetRepsLow != null &&
                                    entry.planned.targetRepsHigh != null
                                ? l10n.repsRange(
                                    entry.planned.targetRepsLow!,
                                    entry.planned.targetRepsHigh!,
                                  )
                                : l10n.repsNotSet;
                            return Dismissible(
                              key: ValueKey(entry.planned.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: c.danger.withValues(alpha: 0.15),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: AppSpacing.lg),
                                child: Icon(Icons.delete_outline, color: c.danger),
                              ),
                              onDismissed: (_) => ref
                                  .read(splitControllerProvider)
                                  .removeExerciseFromDay(entry.planned.id),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(entry.exercise.name,
                                        style: Theme.of(context).textTheme.titleMedium),
                                    const SizedBox(height: 2),
                                    Text(
                                      l10n.setsRepsRangeSummary(entry.planned.targetSets, repsRange),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: c.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                if (planned.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xxl, 0, AppSpacing.xxl, AppSpacing.xxl),
                    child: LiftPrimaryButton(
                      label: l10n.startWorkoutFromThisDay,
                      icon: Icons.play_arrow_rounded,
                      onPressed: () =>
                          context.push('/active-workout', extra: splitDayId),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
