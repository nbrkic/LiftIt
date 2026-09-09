import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/weight_format.dart';
import '../../../database/enums.dart';
import '../../../database/queries/stats_queries.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/tokens/app_typography.dart';
import '../../../design/widgets/chart_theme.dart';
import '../../../design/widgets/empty_state.dart';
import '../../../l10n/app_localizations.dart';
import '../../history/providers/history_providers.dart';
import '../../profile/providers/profile_providers.dart';
import '../../profile/providers/stats_providers.dart';
import '../../profile/utils/volume_stats.dart';
import '../providers/dashboard_providers.dart';
import '../utils/dashboard_stats.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final theme = Theme.of(context);
    final chart = ChartTheme.of(context);
    final sessionsAsync = ref.watch(pastSessionsProvider);
    final allSetsAsync = ref.watch(allWorkingSetsProvider);
    final muscleVolumeAsync = ref.watch(muscleGroupVolumeProvider);
    final sessionVolumesAsync = ref.watch(sessionVolumesProvider);
    final unit = ref.watch(preferredWeightUnitProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statsTitle),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      body: sessionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text(l10n.errorMessage('$error'))),
        data: (sessions) {
          if (sessions.isEmpty) {
            return LiftEmptyState(message: l10n.finishWorkoutToSeeStats);
          }

          final streak = computeStreakWeeks(sessions);
          final avgPerWeek = computeAverageWorkoutsPerWeek(sessions);
          final avgDuration = computeAverageDuration(sessions);

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            children: [
              Row(
                children: [
                  Expanded(
                    child: _StatCol(value: '${sessions.length}', label: l10n.totalWorkouts),
                  ),
                  Expanded(
                    child: _StatCol(value: l10n.streakWeeks(streak), label: l10n.currentStreak),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              Row(
                children: [
                  Expanded(
                    child: _StatCol(value: avgPerWeek.toStringAsFixed(1), label: l10n.avgPerWeek),
                  ),
                  Expanded(
                    child: _StatCol(
                      value: avgDuration == null ? '-' : '${avgDuration.inMinutes}',
                      label: l10n.avgDuration,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxxl),
              Text(l10n.trainingVolumeWeekly, style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.lg),
              sessionVolumesAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (error, stack) => const SizedBox.shrink(),
                data: (sessions) {
                  final weeks = computeWeeklyVolume(sessions);
                  if (weeks.every((w) => w.volume == 0)) {
                    return Text(l10n.noCompletedWorkoutsYet,
                        style: theme.textTheme.bodyMedium?.copyWith(color: c.textSecondary));
                  }
                  return SizedBox(
                    height: 160,
                    child: _VolumeChart(weeks: weeks, unit: unit, chart: chart),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xxxl),
              Text(l10n.personalRecords, style: theme.textTheme.titleMedium),
              Divider(height: AppSpacing.xl, color: c.divider),
              allSetsAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) => Text(l10n.errorMessage('$error')),
                data: (allSets) {
                  final prs = computeAllPrs(allSets);
                  if (prs.isEmpty) {
                    return Text(l10n.noSetsLoggedYet,
                        style: theme.textTheme.bodyMedium?.copyWith(color: c.textSecondary));
                  }
                  return Column(
                    children: prs
                        .map((pr) => _PrRow(
                              name: pr.exerciseName,
                              weightReps: l10n.timesReps(
                                  formatWeight(pr.oneRepMax.set.weight, unit), pr.oneRepMax.set.reps),
                              oneRm:
                                  '${pr.oneRepMax.isTested ? '' : '~'}${formatWeight(pr.oneRepMax.weight, unit)}',
                              onTap: () => context.push('/exercises/${pr.exerciseId}'),
                            ))
                        .toList(),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xxxl),
              Text(l10n.volumeByMuscleGroup, style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.lg),
              muscleVolumeAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (error, stack) => const SizedBox.shrink(),
                data: (groups) {
                  if (groups.isEmpty) {
                    return Text(l10n.noSetsLoggedYet,
                        style: theme.textTheme.bodyMedium?.copyWith(color: c.textSecondary));
                  }
                  final sorted = [...groups]..sort((a, b) => b.volume.compareTo(a.volume));
                  final total = sorted.fold(0.0, (sum, g) => sum + g.volume);
                  return Column(
                    children: [
                      SizedBox(height: 200, child: _MuscleGroupPieChart(groups: sorted)),
                      const SizedBox(height: AppSpacing.lg),
                      ...sorted.asMap().entries.map((e) {
                        final color = ChartTheme.pieColors[e.key % ChartTheme.pieColors.length];
                        final pct = total == 0 ? 0.0 : e.value.volume / total * 100;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(e.value.muscleGroup.label(context),
                                    style: theme.textTheme.bodyMedium),
                              ),
                              Text(
                                l10n.percentValue(pct.toStringAsFixed(0)),
                                style: AppTypography.numeral(size: 14, color: c.textSecondary),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatCol extends StatelessWidget {
  final String value;
  final String label;

  const _StatCol({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTypography.numeral(size: 36, color: c.textPrimary)),
        const SizedBox(height: AppSpacing.xs),
        Text(label.toUpperCase(), style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}

class _PrRow extends StatelessWidget {
  final String name;
  final String weightReps;
  final String oneRm;
  final VoidCallback onTap;

  const _PrRow({required this.name, required this.weightReps, required this.oneRm, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Container(width: 3, height: 30, color: c.violet),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: theme.textTheme.bodyMedium),
                  Text(weightReps, style: theme.textTheme.bodySmall?.copyWith(color: c.textSecondary)),
                ],
              ),
            ),
            Text(oneRm, style: AppTypography.numeral(size: 17, color: c.violetLight)),
          ],
        ),
      ),
    );
  }
}

class _VolumeChart extends StatelessWidget {
  final List<WeeklyVolume> weeks;
  final WeightUnit unit;
  final ChartTheme chart;

  const _VolumeChart({required this.weeks, required this.unit, required this.chart});

  @override
  Widget build(BuildContext context) {
    final displayVolumes = weeks.map((w) => displayWeight(w.volume, unit)).toList();
    final maxVolume = displayVolumes.fold(0.0, (a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        gridData: chart.grid,
        borderData: chart.border,
        maxY: maxVolume == 0 ? 1 : maxVolume * 1.2,
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) =>
                  Text(value.round().toString(), style: chart.axisLabelStyle),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              getTitlesWidget: (value, meta) {
                final index = value.round();
                if (index < 0 || index >= weeks.length) return const SizedBox.shrink();
                final date = weeks[index].weekStart;
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('${date.day}.${date.month}.', style: chart.axisLabelStyle),
                );
              },
            ),
          ),
        ),
        barGroups: displayVolumes
            .asMap()
            .entries
            .map((e) => BarChartGroupData(x: e.key, barRods: [chart.bar(e.value)]))
            .toList(),
      ),
    );
  }
}

class _MuscleGroupPieChart extends StatelessWidget {
  final List<MuscleGroupVolume> groups;

  const _MuscleGroupPieChart({required this.groups});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 44,
        sections: groups.asMap().entries.map((e) {
          final color = ChartTheme.pieColors[e.key % ChartTheme.pieColors.length];
          return PieChartSectionData(
            value: e.value.volume,
            color: color,
            title: '',
            radius: 54,
          );
        }).toList(),
      ),
    );
  }
}
