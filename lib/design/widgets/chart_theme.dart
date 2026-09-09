import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';

// fl_chart style presets so every chart in the app (weekly volume, 1RM
// progress, bodyweight trend, muscle-group split) shares one restrained
// visual language instead of default fl_chart styling.
class ChartTheme {
  final LiftColors colors;
  const ChartTheme(this.colors);

  factory ChartTheme.of(BuildContext context) => ChartTheme(context.colors);

  FlGridData get grid => FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) => FlLine(color: colors.divider, strokeWidth: 1),
      );

  FlBorderData get border => FlBorderData(show: false);

  TextStyle get axisLabelStyle => TextStyle(
        color: colors.textSecondary,
        fontSize: 10,
        fontWeight: FontWeight.w600,
      );

  LineTouchData lineTouch({required String Function(FlSpot spot) label}) => LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => colors.surfaceElevated,
          getTooltipItems: (spots) => spots
              .map((spot) => LineTooltipItem(
                    label(spot),
                    TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w700),
                  ))
              .toList(),
        ),
      );

  LineChartBarData line(List<FlSpot> spots, {Color? color}) {
    final lineColor = color ?? colors.violet;
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.2,
      barWidth: 2.5,
      color: lineColor,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, bar, index) =>
            FlDotCirclePainter(radius: 3, color: lineColor, strokeWidth: 0),
      ),
      belowBarData: BarAreaData(show: true, color: lineColor.withValues(alpha: 0.12)),
    );
  }

  BarChartRodData bar(double value, {Color? color}) {
    return BarChartRodData(
      toY: value,
      color: color ?? colors.violet,
      width: 14,
      borderRadius: BorderRadius.zero,
    );
  }

  static const pieColors = [
    Color(0xFF8B5CF6),
    Color(0xFF4ADE80),
    Color(0xFFF87171),
    Color(0xFFD9A441),
    Color(0xFFA78BFA),
    Color(0xFF60A5FA),
    Color(0xFFF472B6),
    Color(0xFF34D399),
    Color(0xFF6D3FE8),
    Color(0xFFFBBF24),
    Color(0xFF38BDF8),
    Color(0xFF94A3B8),
  ];
}
