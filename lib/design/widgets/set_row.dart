import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_motion.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

// The single most-repeated component in the app — a logged set as a compact
// row (not a card) with a thin violet tick on the leading edge and
// tabular-figure "weight x reps". Reused in Active Workout, Exercise Detail
// history, and Session Detail so a "logged set" always looks the same
// wherever it appears.
class SetRow extends StatefulWidget {
  final int setNumber;
  final String weightLabel;
  final int reps;
  final double? rpe;
  final String? note;
  final bool isWarmup;
  final VoidCallback? onDelete;
  final bool justLogged;

  const SetRow({
    super.key,
    required this.setNumber,
    required this.weightLabel,
    required this.reps,
    this.rpe,
    this.note,
    this.isWarmup = false,
    this.onDelete,
    this.justLogged = false,
  });

  @override
  State<SetRow> createState() => _SetRowState();
}

class _SetRowState extends State<SetRow> with SingleTickerProviderStateMixin {
  AnimationController? _flash;

  @override
  void initState() {
    super.initState();
    if (widget.justLogged) {
      _flash = AnimationController(vsync: this, duration: AppMotion.slow * 2)..forward();
    }
  }

  @override
  void dispose() {
    _flash?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final theme = Theme.of(context);
    final tickColor = widget.isWarmup ? c.textSecondary.withValues(alpha: 0.4) : c.violet;

    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 3, height: 32, color: tickColor),
          const SizedBox(width: AppSpacing.md),
          SizedBox(
            width: 22,
            child: Text(
              '${widget.setNumber}',
              style: AppTypography.numeral(size: 13, color: c.textSecondary, weight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.weightLabel,
                      style: AppTypography.numeral(size: 17, color: c.textPrimary),
                    ),
                    Text('  ×  ', style: theme.textTheme.bodyMedium?.copyWith(color: c.textSecondary)),
                    Text(
                      '${widget.reps}',
                      style: AppTypography.numeral(size: 17, color: c.textPrimary),
                    ),
                    if (widget.rpe != null) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Text('RPE ${widget.rpe}', style: theme.textTheme.bodySmall),
                    ],
                    if (widget.isWarmup) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Text('warm-up', style: theme.textTheme.bodySmall?.copyWith(color: c.violetLight)),
                    ],
                  ],
                ),
                if (widget.note != null && widget.note!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      widget.note!,
                      style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                    ),
                  ),
              ],
            ),
          ),
          if (widget.onDelete != null)
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 18),
              color: c.textSecondary,
              onPressed: widget.onDelete,
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );

    if (_flash == null) return row;
    return AnimatedBuilder(
      animation: _flash!,
      builder: (context, child) {
        final t = 1 - _flash!.value;
        return DecoratedBox(
          decoration: BoxDecoration(color: c.violet.withValues(alpha: 0.10 * t)),
          child: child,
        );
      },
      child: row,
    );
  }
}
