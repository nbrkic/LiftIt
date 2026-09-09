import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

// The "big number" signature: a large Space Grotesk numeral with a small
// tracked-uppercase label beneath, no card required. Used anywhere a number
// is the point — PRs, current bodyweight, streak, volume, duration.
class StatBlock extends StatelessWidget {
  final String value;
  final String label;
  final double valueSize;
  final Color? valueColor;
  final CrossAxisAlignment alignment;

  const StatBlock({
    super.key,
    required this.value,
    required this.label,
    this.valueSize = 32,
    this.valueColor,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: AppTypography.numeral(size: valueSize, color: valueColor ?? c.textPrimary)),
        const SizedBox(height: AppSpacing.xs),
        Text(label.toUpperCase(), style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
