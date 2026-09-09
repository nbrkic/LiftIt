import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/weight_format.dart';
import '../../../database/app_database.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/lift_button.dart';
import '../../../design/widgets/stat_block.dart';
import '../../../l10n/app_localizations.dart';
import '../../exercises/providers/exercise_stats_providers.dart';
import '../../exercises/utils/exercise_stats.dart';
import '../../profile/providers/profile_providers.dart';

class FinishedGroup {
  final Exercise exercise;
  final List<WorkoutSet> sets;
  FinishedGroup({required this.exercise, required this.sets});
}

// Shown in place of ActiveWorkoutScreen's body right after finishing — a
// brief, restrained moment (strong typography, no confetti) summarizing the
// session and calling out any exercise where the best set logged today is
// now the all-time best for that exercise.
class WorkoutCompletionView extends ConsumerWidget {
  final Duration duration;
  final double volume;
  final List<FinishedGroup> groups;
  final VoidCallback onDone;

  const WorkoutCompletionView({
    super.key,
    required this.duration,
    required this.volume,
    required this.groups,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context)!;
    final unit = ref.watch(preferredWeightUnitProvider);
    final totalSets = groups.fold(0, (sum, g) => sum + g.sets.length);

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              Icon(Icons.check_circle_rounded, color: c.violet, size: 52),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.workoutCompleteTitle,
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatBlock(
                    value: '${duration.inMinutes}',
                    label: l10n.minutesLabel,
                    alignment: CrossAxisAlignment.center,
                  ),
                  StatBlock(
                    value: formatWeight(volume, unit, decimals: 0),
                    label: l10n.volumeLabel,
                    alignment: CrossAxisAlignment.center,
                  ),
                  StatBlock(
                    value: '${groups.length}',
                    label: groups.length == 1 ? l10n.exerciseLabelSingular : l10n.exerciseLabelPlural,
                    alignment: CrossAxisAlignment.center,
                  ),
                  StatBlock(
                    value: '$totalSets',
                    label: l10n.setsLabel,
                    alignment: CrossAxisAlignment.center,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxxl),
              Flexible(
                flex: 3,
                child: ListView(
                  shrinkWrap: true,
                  children: groups.map((g) => _PrCheck(group: g)).toList(),
                ),
              ),
              const Spacer(),
              LiftPrimaryButton(label: l10n.doneButton, onPressed: onDone),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrCheck extends ConsumerWidget {
  final FinishedGroup group;

  const _PrCheck({required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allSetsAsync = ref.watch(exerciseSetsProvider(group.exercise.id));
    final allSets = allSetsAsync.value;
    if (allSets == null) return const SizedBox.shrink();

    final best = computeOneRepMax(allSets);
    final sessionSetIds = group.sets.map((s) => s.id).toSet();
    final isPr = best != null && sessionSetIds.contains(best.set.id);
    if (!isPr) return const SizedBox.shrink();

    final c = context.colors;
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(Icons.trending_up_rounded, color: c.violet, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(group.exercise.name, style: Theme.of(context).textTheme.bodyMedium)),
          Text(
            l10n.newPrTag,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: c.violet),
          ),
        ],
      ),
    );
  }
}
