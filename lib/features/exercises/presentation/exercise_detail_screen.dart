import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/weight_format.dart';
import '../../../database/app_database.dart';
import '../../../database/enums.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/chart_theme.dart';
import '../../../design/widgets/empty_state.dart';
import '../../../design/widgets/set_row.dart';
import '../../../design/widgets/stat_block.dart';
import '../../../l10n/app_localizations.dart';
import '../../profile/providers/profile_providers.dart';
import '../providers/exercise_providers.dart';
import '../providers/exercise_stats_providers.dart';
import '../utils/exercise_stats.dart';

class ExerciseDetailScreen extends ConsumerWidget {
  final int exerciseId;

  const ExerciseDetailScreen({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final exercisesAsync = ref.watch(exerciseListProvider);
    final setsAsync = ref.watch(exerciseSetsProvider(exerciseId));
    final unit = ref.watch(preferredWeightUnitProvider);
    final l10n = AppLocalizations.of(context)!;

    Exercise? exercise;
    for (final e in exercisesAsync.value ?? const <Exercise>[]) {
      if (e.id == exerciseId) {
        exercise = e;
        break;
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(exercise?.name ?? l10n.exerciseFallbackTitle)),
      body: setsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text(l10n.errorMessage('$error'))),
        data: (sets) {
          if (sets.isEmpty) {
            return LiftEmptyState(message: l10n.noSetsLoggedForExercise);
          }
          final oneRm = computeOneRepMax(sets)!;
          final topSets = computeTopSetProgress(sets);

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            children: [
              Text(l10n.personalRecord.toUpperCase(), style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: AppSpacing.sm),
              StatBlock(
                value: '${oneRm.isTested ? '' : '~'}${formatWeight(oneRm.weight, unit)}',
                label: oneRm.isTested ? l10n.oneRepMaxTested : l10n.estimatedOneRepMax,
                valueSize: 44,
                valueColor: c.violetLight,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.timesReps(formatWeight(oneRm.set.weight, unit), oneRm.set.reps) +
                    (oneRm.set.rpe != null ? l10n.rpeSuffix('${oneRm.set.rpe}') : ''),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: c.textSecondary),
              ),
              if (topSets.length > 1) ...[
                const SizedBox(height: AppSpacing.xxxl),
                Text(l10n.progressChartTitle, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(height: 200, child: _ProgressChart(topSets: topSets, unit: unit)),
              ],
              const SizedBox(height: AppSpacing.xxxl),
              Text(l10n.historyLabel, style: Theme.of(context).textTheme.titleMedium),
              Divider(height: AppSpacing.xl, color: c.divider),
              ...sets.reversed.map((set) => SetRow(
                    setNumber: set.setNumber,
                    weightLabel: formatWeight(set.weight, unit),
                    reps: set.reps,
                    rpe: set.rpe,
                    note: set.notes,
                    isWarmup: set.isWarmup,
                  )),
            ],
          );
        },
      ),
    );
  }
}

class _ProgressChart extends StatelessWidget {
  final List<WorkoutSet> topSets;
  final WeightUnit unit;

  const _ProgressChart({required this.topSets, required this.unit});

  @override
  Widget build(BuildContext context) {
    final chart = ChartTheme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final spots = topSets
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), displayWeight(e.value.weight, unit)))
        .toList();

    return LineChart(
      LineChartData(
        gridData: chart.grid,
        borderData: chart.border,
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 44, getTitlesWidget: (value, meta) {
              return Text('${value.round()}${unitLabel(unit)}', style: chart.axisLabelStyle);
            }),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              interval: (topSets.length / 4).clamp(1, double.infinity).roundToDouble(),
              getTitlesWidget: (value, meta) {
                final index = value.round();
                if (index < 0 || index >= topSets.length) return const SizedBox.shrink();
                final date = topSets[index].completedAt;
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('${date.day}.${date.month}.', style: chart.axisLabelStyle),
                );
              },
            ),
          ),
        ),
        lineTouchData: chart.lineTouch(label: (spot) {
          final set = topSets[spot.x.toInt()];
          return l10n.timesReps(formatWeight(set.weight, unit), set.reps);
        }),
        lineBarsData: [chart.line(spots)],
      ),
    );
  }
}
