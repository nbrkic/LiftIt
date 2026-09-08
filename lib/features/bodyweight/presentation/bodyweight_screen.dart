import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/weight_format.dart';
import '../../../database/app_database.dart';
import '../../../database/enums.dart';
import '../../profile/presentation/log_bodyweight_sheet.dart';
import '../../profile/providers/profile_providers.dart';

class BodyweightScreen extends ConsumerWidget {
  const BodyweightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestWeightAsync = ref.watch(latestBodyweightProvider);
    final historyAsync = ref.watch(bodyweightHistoryProvider);
    final unit = ref.watch(preferredWeightUnitProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Bodyweight')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => const LogBodyweightSheet(),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Log Weigh-in'),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            latestWeightAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (error, stack) => const SizedBox.shrink(),
              data: (latest) => Text(
                latest == null ? 'No weigh-ins yet' : 'Current: ${formatWeight(latest.weightKg, unit)}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 16),
            historyAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (error, stack) => const SizedBox.shrink(),
              data: (history) {
                if (history.length < 2) return const SizedBox.shrink();
                final ascending = history.reversed.toList();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SizedBox(height: 220, child: _BodyweightChart(entries: ascending, unit: unit)),
                );
              },
            ),
            Text('History', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            historyAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text('Error: $error'),
              data: (history) {
                if (history.isEmpty) return const Text('No weigh-ins yet — tap + to log one.');
                return Column(
                  children: history
                      .map((entry) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(formatWeight(entry.weightKg, unit)),
                            subtitle: Text(
                              entry.notes != null && entry.notes!.isNotEmpty
                                  ? '${_formatDate(entry.loggedAt)} • ${entry.notes}'
                                  : _formatDate(entry.loggedAt),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () =>
                                  ref.read(profileControllerProvider).deleteBodyweightLog(entry.id),
                            ),
                          ))
                      .toList(),
                );
              },
            ),
            // Extra bottom space so the last row isn't hidden behind the FAB.
            const SizedBox(height: 72),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}

class _BodyweightChart extends StatelessWidget {
  final List<BodyweightLog> entries; // ascending by loggedAt — one point per entry
  final WeightUnit unit;

  const _BodyweightChart({required this.entries, required this.unit});

  @override
  Widget build(BuildContext context) {
    final displayWeights = entries.map((e) => displayWeight(e.weightKg, unit)).toList();
    final spots = displayWeights
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();
    final minWeight = displayWeights.reduce((a, b) => a < b ? a : b);
    final maxWeight = displayWeights.reduce((a, b) => a > b ? a : b);
    final padding = ((maxWeight - minWeight) * 0.15).clamp(1.0, double.infinity);

    return LineChart(
      LineChartData(
        minY: minWeight - padding,
        maxY: maxWeight + padding,
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
              interval: (entries.length / 4).clamp(1, double.infinity).roundToDouble(),
              getTitlesWidget: (value, meta) {
                final index = value.round();
                if (index < 0 || index >= entries.length) return const SizedBox.shrink();
                final date = entries[index].loggedAt;
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('${date.day}.${date.month}.', style: const TextStyle(fontSize: 10)),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) => touchedSpots
                .map((spot) => LineTooltipItem(
                      formatWeight(entries[spot.x.toInt()].weightKg, unit),
                      const TextStyle(fontWeight: FontWeight.bold),
                    ))
                .toList(),
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
