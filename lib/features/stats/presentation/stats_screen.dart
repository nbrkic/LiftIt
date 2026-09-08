import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/weight_format.dart';
import '../../../database/enums.dart';
import '../../../database/queries/stats_queries.dart';
import '../../../l10n/app_localizations.dart';
import '../../history/providers/history_providers.dart';
import '../../profile/providers/profile_providers.dart';
import '../../profile/providers/stats_providers.dart';
import '../../profile/utils/volume_stats.dart';
import '../providers/dashboard_providers.dart';
import '../utils/dashboard_stats.dart';

const _muscleGroupColors = [
  Color(0xFFE57373), Color(0xFF64B5F6), Color(0xFF81C784), Color(0xFFFFB74D),
  Color(0xFFBA68C8), Color(0xFF4DB6AC), Color(0xFFF06292), Color(0xFFA1887F),
  Color(0xFF9575CD), Color(0xFFFFD54F), Color(0xFF4FC3F7), Color(0xFF90A4AE),
];

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            return Center(child: Text(l10n.finishWorkoutToSeeStats));
          }

          final streak = computeStreakWeeks(sessions);
          final avgPerWeek = computeAverageWorkoutsPerWeek(sessions);
          final avgDuration = computeAverageDuration(sessions);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.6,
                children: [
                  _StatTile(label: l10n.totalWorkouts, value: '${sessions.length}'),
                  _StatTile(label: l10n.currentStreak, value: l10n.streakWeeks(streak)),
                  _StatTile(label: l10n.avgPerWeek, value: avgPerWeek.toStringAsFixed(1)),
                  _StatTile(
                    label: l10n.avgDuration,
                    value: avgDuration == null ? '-' : l10n.durationMinutes(avgDuration.inMinutes),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(l10n.trainingVolumeWeekly, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              sessionVolumesAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (error, stack) => const SizedBox.shrink(),
                data: (sessions) {
                  final weeks = computeWeeklyVolume(sessions);
                  if (weeks.every((w) => w.volume == 0)) {
                    return Text(l10n.noCompletedWorkoutsYet);
                  }
                  return SizedBox(height: 160, child: _VolumeChart(weeks: weeks, unit: unit));
                },
              ),
              const SizedBox(height: 24),
              Text(l10n.personalRecords, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              allSetsAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) => Text(l10n.errorMessage('$error')),
                data: (allSets) {
                  final prs = computeAllPrs(allSets);
                  if (prs.isEmpty) return Text(l10n.noSetsLoggedYet);
                  return Column(
                    children: prs
                        .map((pr) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(pr.exerciseName),
                              subtitle: Text(
                                l10n.timesReps(formatWeight(pr.oneRepMax.set.weight, unit), pr.oneRepMax.set.reps),
                              ),
                              trailing: Text(
                                '${pr.oneRepMax.isTested ? '' : '~'}${formatWeight(pr.oneRepMax.weight, unit)}',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              onTap: () => context.push('/exercises/${pr.exerciseId}'),
                            ))
                        .toList(),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(l10n.volumeByMuscleGroup, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              muscleVolumeAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (error, stack) => const SizedBox.shrink(),
                data: (groups) {
                  if (groups.isEmpty) return Text(l10n.noSetsLoggedYet);
                  final sorted = [...groups]..sort((a, b) => b.volume.compareTo(a.volume));
                  final total = sorted.fold(0.0, (sum, g) => sum + g.volume);
                  return Column(
                    children: [
                      SizedBox(height: 220, child: _MuscleGroupPieChart(groups: sorted)),
                      const SizedBox(height: 12),
                      ...sorted.asMap().entries.map((e) {
                        final color = _muscleGroupColors[e.key % _muscleGroupColors.length];
                        final pct = total == 0 ? 0.0 : e.value.volume / total * 100;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(width: 12, height: 12, color: color),
                              const SizedBox(width: 8),
                              Expanded(child: Text(e.value.muscleGroup.label(context))),
                              Text(l10n.percentValue(pct.toStringAsFixed(0))),
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

class _StatTile extends StatelessWidget {
  final String label;
  final String value;

  const _StatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _VolumeChart extends StatelessWidget {
  final List<WeeklyVolume> weeks;
  final WeightUnit unit;

  const _VolumeChart({required this.weeks, required this.unit});

  @override
  Widget build(BuildContext context) {
    final displayVolumes = weeks.map((w) => displayWeight(w.volume, unit)).toList();
    final maxVolume = displayVolumes.fold(0.0, (a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        maxY: maxVolume == 0 ? 1 : maxVolume * 1.2,
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
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
                  child: Text('${date.day}.${date.month}.', style: const TextStyle(fontSize: 10)),
                );
              },
            ),
          ),
        ),
        barGroups: displayVolumes
            .asMap()
            .entries
            .map((e) => BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value,
                      color: Theme.of(context).colorScheme.primary,
                      width: 16,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ],
                ))
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
        centerSpaceRadius: 40,
        sections: groups.asMap().entries.map((e) {
          final color = _muscleGroupColors[e.key % _muscleGroupColors.length];
          return PieChartSectionData(
            value: e.value.volume,
            color: color,
            title: '',
            radius: 60,
          );
        }).toList(),
      ),
    );
  }
}
