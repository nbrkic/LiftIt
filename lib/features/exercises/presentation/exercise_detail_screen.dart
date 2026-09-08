import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/weight_format.dart';
import '../../../database/app_database.dart';
import '../../../database/enums.dart';
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
            return Center(child: Text(l10n.noSetsLoggedForExercise));
          }
          final oneRm = computeOneRepMax(sets)!;
          final points = computeProgressPoints(sets);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.personalRecord, style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 4),
                      Text(
                        l10n.timesReps(formatWeight(oneRm.set.weight, unit), oneRm.set.reps) +
                            (oneRm.set.rpe != null ? l10n.rpeSuffix('${oneRm.set.rpe}') : ''),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        '${oneRm.isTested ? l10n.oneRepMaxTested : l10n.estimatedOneRepMax}: '
                        '${formatWeight(oneRm.weight, unit)}',
                      ),
                    ],
                  ),
                ),
              ),
              if (points.length > 1) ...[
                const SizedBox(height: 24),
                Text(l10n.progressChartTitle, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                SizedBox(height: 200, child: _ProgressChart(points: points, unit: unit)),
              ],
              const SizedBox(height: 24),
              Text(l10n.historyLabel, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ...sets.reversed.map((set) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      l10n.timesReps(formatWeight(set.weight, unit), set.reps) +
                          (set.rpe != null ? l10n.rpeSuffix('${set.rpe}') : ''),
                    ),
                    subtitle: Text(_formatDate(set.completedAt)),
                  )),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}

class _ProgressChart extends StatelessWidget {
  final List<ProgressPoint> points;
  final WeightUnit unit;

  const _ProgressChart({required this.points, required this.unit});

  @override
  Widget build(BuildContext context) {
    final spots = points
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), displayWeight(e.value.estimated1Rm, unit)))
        .toList();

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              interval: (points.length / 4).clamp(1, double.infinity).roundToDouble(),
              getTitlesWidget: (value, meta) {
                final index = value.round();
                if (index < 0 || index >= points.length) return const SizedBox.shrink();
                final date = points[index].date;
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('${date.day}.${date.month}.', style: const TextStyle(fontSize: 10)),
                );
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 3,
            color: Theme.of(context).colorScheme.primary,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
            ),
          ),
        ],
      ),
    );
  }
}
