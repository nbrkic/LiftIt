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
import '../../../design/widgets/stat_block.dart';
import '../../../l10n/app_localizations.dart';
import '../../profile/presentation/log_bodyweight_sheet.dart';
import '../../profile/providers/profile_providers.dart';

class BodyweightScreen extends ConsumerWidget {
  const BodyweightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final theme = Theme.of(context);
    final latestWeightAsync = ref.watch(latestBodyweightProvider);
    final historyAsync = ref.watch(bodyweightHistoryProvider);
    final unit = ref.watch(preferredWeightUnitProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.bodyweightTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => const LogBodyweightSheet(),
        ),
        icon: const Icon(Icons.add),
        label: Text(l10n.bodyweightLogWeighIn),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          children: [
            latestWeightAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (error, stack) => const SizedBox.shrink(),
              data: (latest) => latest == null
                  ? Text(l10n.bodyweightNoWeighInsYet,
                      style: theme.textTheme.bodyLarge?.copyWith(color: c.textSecondary))
                  : StatBlock(
                      value: formatWeight(latest.weightKg, unit),
                      label: l10n.bodyweightTitle,
                      valueSize: 44,
                    ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            historyAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (error, stack) => const SizedBox.shrink(),
              data: (history) {
                if (history.length < 2) return const SizedBox.shrink();
                final ascending = history.reversed.toList();
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                  child: SizedBox(height: 200, child: _BodyweightChart(entries: ascending, unit: unit)),
                );
              },
            ),
            Text(l10n.historyLabel, style: theme.textTheme.titleMedium),
            Divider(height: AppSpacing.xl, color: c.divider),
            historyAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text(l10n.errorMessage('$error')),
              data: (history) {
                if (history.isEmpty) {
                  return LiftEmptyState(message: l10n.bodyweightNoWeighInsYetTapToLog);
                }
                return Column(
                  children: history
                      .map((entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(formatWeight(entry.weightKg, unit),
                                          style: theme.textTheme.bodyLarge),
                                      Text(
                                        entry.notes != null && entry.notes!.isNotEmpty
                                            ? l10n.bodyweightHistoryRow(
                                                _formatDate(entry.loggedAt), entry.notes!)
                                            : _formatDate(entry.loggedAt),
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(color: c.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 20),
                                  color: c.textSecondary,
                                  onPressed: () => ref
                                      .read(profileControllerProvider)
                                      .deleteBodyweightLog(entry.id),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                );
              },
            ),
            // Extra bottom space so the last row isn't hidden behind the FAB.
            const SizedBox(height: AppSpacing.giant),
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
    final chart = ChartTheme.of(context);
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
        gridData: chart.grid,
        borderData: chart.border,
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
              interval: (entries.length / 4).clamp(1, double.infinity).roundToDouble(),
              getTitlesWidget: (value, meta) {
                final index = value.round();
                if (index < 0 || index >= entries.length) return const SizedBox.shrink();
                final date = entries[index].loggedAt;
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('${date.day}.${date.month}.', style: chart.axisLabelStyle),
                );
              },
            ),
          ),
        ),
        lineTouchData: chart.lineTouch(label: (spot) => formatWeight(entries[spot.x.toInt()].weightKg, unit)),
        lineBarsData: [chart.line(spots)],
      ),
    );
  }
}
