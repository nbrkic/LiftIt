import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/chart_theme.dart';
import '../../../design/widgets/empty_state.dart';
import '../../../l10n/app_localizations.dart';
import '../../profile/providers/profile_providers.dart';
import '../providers/nutrition_trends_providers.dart';
import '../utils/nutrition_trends.dart';

class NutritionTrendsScreen extends ConsumerWidget {
  const NutritionTrendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final theme = Theme.of(context);
    final chart = ChartTheme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final entriesAsync = ref.watch(allFoodLogEntriesProvider);
    final calorieGoal = ref.watch(userProfileProvider).value?.dailyCalorieGoal;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.nutritionTrendsTitle)),
      body: SafeArea(
        top: false,
        child: entriesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text(l10n.errorMessage('$error'))),
          data: (entries) {
            if (entries.isEmpty) {
              return LiftEmptyState(message: l10n.nutritionTrendsEmpty);
            }
            final weeks = computeWeeklyNutrition(entries);
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              children: [
                Text(l10n.nutritionTrendsCaloriesLabel, style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  height: 160,
                  child: _CaloriesChart(weeks: weeks, chart: chart, goal: calorieGoal),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                Text(l10n.nutritionTrendsMacrosLabel, style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(height: 160, child: _MacrosChart(weeks: weeks, colors: c, chart: chart)),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    _MacroLegendDot(color: c.violet, label: l10n.nutritionProteinLabel),
                    const SizedBox(width: AppSpacing.lg),
                    _MacroLegendDot(color: c.warning, label: l10n.nutritionCarbsLabel),
                    const SizedBox(width: AppSpacing.lg),
                    _MacroLegendDot(color: c.success, label: l10n.nutritionFatLabel),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CaloriesChart extends StatelessWidget {
  final List<WeeklyNutrition> weeks;
  final ChartTheme chart;
  final int? goal;

  const _CaloriesChart({required this.weeks, required this.chart, required this.goal});

  @override
  Widget build(BuildContext context) {
    final calories = weeks.map((w) => w.avgCalories).toList();
    final maxCalories = calories.fold(0.0, (a, b) => a > b ? a : b);
    final maxY = [maxCalories, (goal ?? 0).toDouble()].reduce((a, b) => a > b ? a : b) * 1.2;

    return BarChart(
      BarChartData(
        gridData: chart.grid,
        borderData: chart.border,
        maxY: maxY == 0 ? 1 : maxY,
        extraLinesData: goal == null
            ? const ExtraLinesData()
            : ExtraLinesData(horizontalLines: [
                HorizontalLine(
                  y: goal!.toDouble(),
                  color: chart.colors.textSecondary,
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
              ]),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 48,
              getTitlesWidget: (value, meta) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Text(
                  value.round().toString(),
                  style: chart.axisLabelStyle,
                  textAlign: TextAlign.right,
                ),
              ),
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
        barGroups: calories
            .asMap()
            .entries
            .map((e) => BarChartGroupData(x: e.key, barRods: [chart.bar(e.value)]))
            .toList(),
      ),
    );
  }
}

class _MacrosChart extends StatelessWidget {
  final List<WeeklyNutrition> weeks;
  final LiftColors colors;
  final ChartTheme chart;

  const _MacrosChart({required this.weeks, required this.colors, required this.chart});

  @override
  Widget build(BuildContext context) {
    final totals = weeks.map((w) => w.avgProteinG + w.avgCarbsG + w.avgFatG).toList();
    final maxTotal = totals.fold(0.0, (a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        gridData: chart.grid,
        borderData: chart.border,
        maxY: maxTotal == 0 ? 1 : maxTotal * 1.2,
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 44,
              getTitlesWidget: (value, meta) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Text(
                  value.round().toString(),
                  style: chart.axisLabelStyle,
                  textAlign: TextAlign.right,
                ),
              ),
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
        barGroups: weeks.asMap().entries.map((e) {
          final w = e.value;
          final parts = [
            (w.avgProteinG, colors.violet),
            (w.avgCarbsG, colors.warning),
            (w.avgFatG, colors.success),
          ];
          var cursor = 0.0;
          final items = <BarChartRodStackItem>[];
          for (final part in parts) {
            final next = cursor + part.$1;
            items.add(BarChartRodStackItem(cursor, next, part.$2));
            cursor = next;
          }
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: cursor,
                rodStackItems: items,
                width: 14,
                borderRadius: BorderRadius.zero,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MacroLegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _MacroLegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.textSecondary)),
      ],
    );
  }
}
