import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/tokens/app_typography.dart';
import '../../../design/widgets/streak_flame.dart';
import '../../../l10n/app_localizations.dart';
import '../../history/providers/history_providers.dart';
import '../providers/rest_day_providers.dart';
import '../utils/streak_calculator.dart';

class StreakLevelsScreen extends ConsumerWidget {
  const StreakLevelsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final pastSessions = ref.watch(pastSessionsProvider).value ?? const [];
    final restDays = ref.watch(restDaysProvider).value ?? const [];
    final streakDays = computeDailyStreak(pastSessions, restDays);
    final currentTier = currentStreakLevel(streakDays)?.tier;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.streaksTitle)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          children: [
            Center(
              child: Column(
                children: [
                  StreakFlame(level: currentTier ?? 0, size: 64),
                  const SizedBox(height: AppSpacing.md),
                  Text('$streakDays', style: AppTypography.numeral(size: 44, color: c.textPrimary)),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    currentTier != null
                        ? streakLevels[currentTier - 1].nameOf(l10n)
                        : l10n.homeNoStreakYet,
                    style: theme.textTheme.bodyLarge?.copyWith(color: c.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            Text(
              l10n.streakScreenIntro,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(color: c.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            ...streakLevels.map((level) {
              final locked = streakDays < level.daysRequired;
              final isCurrent = level.tier == currentTier;
              final statusLabel = locked
                  ? l10n.streakLockedLabel
                  : isCurrent
                      ? l10n.streakCurrentLevelLabel
                      : l10n.streakAchievedLabel;
              final statusColor = locked ? c.textSecondary : (isCurrent ? c.violetLight : c.textSecondary);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Row(
                  children: [
                    Opacity(
                      opacity: locked ? 0.35 : 1,
                      child: StreakFlame(level: level.tier, size: 22.0 + level.tier * 6),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            level.nameOf(l10n),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: locked ? c.textSecondary : c.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.streakDaysRequired(level.daysRequired),
                            style: theme.textTheme.bodySmall?.copyWith(color: c.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      statusLabel,
                      style: theme.textTheme.labelMedium?.copyWith(color: statusColor),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
