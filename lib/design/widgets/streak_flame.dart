import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';

// The streak "avatar" — a single flame glyph that reads as progressively
// more powerful the higher the tier: dim outline (no streak yet) through
// solid violet, to a near-white hot core with a slow breathing glow at the
// top tier. Kept in the app's violet family rather than literal fire
// colors so it reads as LiftIt's own signature, not a generic flame icon.
class StreakFlame extends StatefulWidget {
  final int level; // 0 (no streak) .. 5 (max tier)
  final double size;

  const StreakFlame({super.key, required this.level, this.size = 32});

  @override
  State<StreakFlame> createState() => _StreakFlameState();
}

class _StreakFlameState extends State<StreakFlame> with SingleTickerProviderStateMixin {
  AnimationController? _pulse;

  @override
  void initState() {
    super.initState();
    _syncPulse();
  }

  @override
  void didUpdateWidget(covariant StreakFlame oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.level != widget.level) _syncPulse();
  }

  void _syncPulse() {
    final maxed = widget.level >= 5;
    if (maxed && _pulse == null) {
      _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))
        ..repeat(reverse: true);
    } else if (!maxed && _pulse != null) {
      _pulse!.dispose();
      _pulse = null;
    }
  }

  @override
  void dispose() {
    _pulse?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final level = widget.level.clamp(0, 5);

    final color = switch (level) {
      0 => c.textSecondary.withValues(alpha: 0.35),
      1 => c.violetLight.withValues(alpha: 0.75),
      2 => c.violetLight,
      3 => c.violet,
      4 => Color.lerp(c.violet, Colors.white, 0.25)!,
      _ => Color.lerp(c.violet, Colors.white, 0.5)!,
    };

    final glowAlpha = switch (level) { 0 || 1 => 0.0, 2 => 0.16, 3 => 0.28, 4 => 0.42, _ => 0.58 };

    Widget flame = Icon(Icons.local_fire_department_rounded, size: widget.size, color: color);

    if (glowAlpha > 0) {
      flame = DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: c.violet.withValues(alpha: glowAlpha),
              blurRadius: widget.size * 0.55,
              spreadRadius: widget.size * 0.04,
            ),
          ],
        ),
        child: flame,
      );
    }

    if (_pulse == null) return flame;
    return AnimatedBuilder(
      animation: _pulse!,
      builder: (context, child) => Transform.scale(scale: 1 + _pulse!.value * 0.08, child: child),
      child: flame,
    );
  }
}
