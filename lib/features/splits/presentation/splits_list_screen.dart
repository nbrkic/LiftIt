import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../database/app_database.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_motion.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/empty_state.dart';
import '../../../l10n/app_localizations.dart';
import '../../workout/presentation/exercise_picker_sheet.dart';
import '../providers/split_providers.dart';
import 'add_split_day_sheet.dart';
import 'create_split_sheet.dart';
import 'target_sets_reps_sheet.dart';

// Splits are browsed as a nested accordion (split -> days -> exercises)
// instead of drilling through push routes, so the whole program stays
// scannable and a workout can be started right from the day you expand.
class SplitsListScreen extends ConsumerStatefulWidget {
  const SplitsListScreen({super.key});

  @override
  ConsumerState<SplitsListScreen> createState() => _SplitsListScreenState();
}

class _SplitsListScreenState extends ConsumerState<SplitsListScreen> {
  int? _expandedSplitId;
  int? _expandedDayId;

  void _toggleSplit(int splitId) {
    setState(() {
      _expandedSplitId = _expandedSplitId == splitId ? null : splitId;
      _expandedDayId = null;
    });
  }

  void _toggleDay(int dayId) {
    setState(() => _expandedDayId = _expandedDayId == dayId ? null : dayId);
  }

  void _onDayDeleted(int dayId) {
    if (_expandedDayId == dayId) setState(() => _expandedDayId = null);
    ref.read(splitControllerProvider).deleteDay(dayId);
  }

  Future<void> _createSplit() async {
    final id = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const CreateSplitSheet(),
    );
    if (id != null && mounted) {
      setState(() {
        _expandedSplitId = id;
        _expandedDayId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final splitsAsync = ref.watch(splitListProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.splitsTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: _createSplit,
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
                final expanded = _expandedSplitId == split.id;
                return Dismissible(
                  key: ValueKey(split.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: c.danger.withValues(alpha: 0.15),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: AppSpacing.lg),
                    child: Icon(Icons.delete_outline, color: c.danger),
                  ),
                  onDismissed: (_) {
                    if (_expandedSplitId == split.id) {
                      setState(() {
                        _expandedSplitId = null;
                        _expandedDayId = null;
                      });
                    }
                    ref.read(splitControllerProvider).deleteSplit(split.id);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InkWell(
                        onTap: () => _toggleSplit(split.id),
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
                              InkResponse(
                                onTap: () => _toggleSplit(split.id),
                                radius: 20,
                                child: Padding(
                                  padding: const EdgeInsets.all(AppSpacing.xs),
                                  child: AnimatedRotation(
                                    turns: expanded ? 0.5 : 0,
                                    duration: AppMotion.base,
                                    curve: AppMotion.enter,
                                    child: Icon(Icons.expand_more_rounded, size: 22, color: c.textSecondary),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AnimatedSize(
                        duration: AppMotion.base,
                        curve: AppMotion.enter,
                        alignment: Alignment.topCenter,
                        child: expanded
                            ? SizedBox(
                                width: double.infinity,
                                child: _DaysSection(
                                  splitId: split.id,
                                  expandedDayId: _expandedDayId,
                                  onToggleDay: _toggleDay,
                                  onDeleteDay: _onDayDeleted,
                                ),
                              )
                            : const SizedBox(width: double.infinity, height: 0),
                      ),
                    ],
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

class _DaysSection extends ConsumerWidget {
  final int splitId;
  final int? expandedDayId;
  final ValueChanged<int> onToggleDay;
  final ValueChanged<int> onDeleteDay;

  const _DaysSection({
    required this.splitId,
    required this.expandedDayId,
    required this.onToggleDay,
    required this.onDeleteDay,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context)!;
    final daysAsync = ref.watch(splitDaysProvider(splitId));

    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.lg, bottom: AppSpacing.sm),
      child: daysAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: SizedBox(
              height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        error: (error, stack) => Text(l10n.errorMessage('$error')),
        data: (days) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (days.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Text(l10n.noDaysYetTapToAdd,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.textSecondary)),
                )
              else
                ...days.map((day) {
                  final expanded = expandedDayId == day.id;
                  return Dismissible(
                    key: ValueKey(day.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: c.danger.withValues(alpha: 0.15),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: AppSpacing.lg),
                      child: Icon(Icons.delete_outline, size: 18, color: c.danger),
                    ),
                    onDismissed: (_) => onDeleteDay(day.id),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        InkWell(
                          onTap: () => onToggleDay(day.id),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    day.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                InkResponse(
                                  onTap: () => onToggleDay(day.id),
                                  radius: 18,
                                  child: Padding(
                                    padding: const EdgeInsets.all(AppSpacing.xs),
                                    child: AnimatedRotation(
                                      turns: expanded ? 0.5 : 0,
                                      duration: AppMotion.base,
                                      curve: AppMotion.enter,
                                      child: Icon(Icons.expand_more_rounded,
                                          size: 20, color: c.textSecondary),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedSize(
                          duration: AppMotion.base,
                          curve: AppMotion.enter,
                          alignment: Alignment.topCenter,
                          child: expanded
                              ? SizedBox(
                                  width: double.infinity,
                                  child: _ExercisesSection(splitDayId: day.id),
                                )
                              : const SizedBox(width: double.infinity, height: 0),
                        ),
                      ],
                    ),
                  );
                }),
              InkWell(
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => AddSplitDaySheet(splitId: splitId),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Row(
                    children: [
                      Icon(Icons.add_rounded, size: 18, color: c.violet),
                      const SizedBox(width: AppSpacing.sm),
                      Text(l10n.addDayButton, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: c.violet)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ExercisesSection extends ConsumerWidget {
  final int splitDayId;

  const _ExercisesSection({required this.splitDayId});

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
      builder: (_) => TargetSetsRepsSheet(exercise: exercise, splitDayId: splitDayId),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context)!;
    final plannedAsync = ref.watch(splitDayExercisesProvider(splitDayId));

    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.lg, bottom: AppSpacing.sm),
      child: plannedAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: SizedBox(
              height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        error: (error, stack) => Text(l10n.errorMessage('$error')),
        data: (planned) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (planned.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Text(l10n.noExercisesYetTapToAdd,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.textSecondary)),
                )
              else
                ...planned.map((entry) {
                  final repsRange = entry.planned.targetRepsLow != null && entry.planned.targetRepsHigh != null
                      ? l10n.repsRange(entry.planned.targetRepsLow!, entry.planned.targetRepsHigh!)
                      : l10n.repsNotSet;
                  return Dismissible(
                    key: ValueKey(entry.planned.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: c.danger.withValues(alpha: 0.15),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: AppSpacing.lg),
                      child: Icon(Icons.delete_outline, size: 18, color: c.danger),
                    ),
                    onDismissed: (_) =>
                        ref.read(splitControllerProvider).removeExerciseFromDay(entry.planned.id),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.exercise.name, style: Theme.of(context).textTheme.bodyLarge),
                          const SizedBox(height: 2),
                          Text(
                            l10n.setsRepsRangeSummary(entry.planned.targetSets, repsRange),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              const SizedBox(height: AppSpacing.sm),
              InkWell(
                onTap: () => _addExercise(context, ref),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Row(
                    children: [
                      Icon(Icons.add_rounded, size: 18, color: c.violet),
                      const SizedBox(width: AppSpacing.sm),
                      Text(l10n.addExerciseFabLabel,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: c.violet)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              FilledButton.icon(
                onPressed: () => context.push('/active-workout', extra: splitDayId),
                icon: const Icon(Icons.play_arrow_rounded, size: 20),
                label: Text(l10n.startWorkoutFromThisDay),
              ),
            ],
          );
        },
      ),
    );
  }
}
