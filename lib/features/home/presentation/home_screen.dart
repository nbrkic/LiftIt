import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/lift_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../history/providers/history_providers.dart';
import '../../splits/providers/split_providers.dart';
import '../../stats/utils/dashboard_stats.dart';
import '../../workout/providers/active_workout_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _greeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.greetingMorning;
    if (hour < 18) return l10n.greetingAfternoon;
    return l10n.greetingEvening;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final activeSession = ref.watch(activeSessionProvider).value;
    final pastSessions = ref.watch(pastSessionsProvider).value;
    final splits = ref.watch(splitListProvider).value;

    String? statusLine;
    if (activeSession != null) {
      statusLine = l10n.workoutInProgressLabel;
    } else if (pastSessions != null && pastSessions.isNotEmpty) {
      final streak = computeStreakWeeks(pastSessions);
      if (streak > 0) statusLine = l10n.homeStreakStatus(streak);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 3),
              Text(_greeting(l10n), style: theme.textTheme.bodyLarge?.copyWith(color: c.textSecondary)),
              const SizedBox(height: AppSpacing.xs),
              Text(l10n.appTitle, style: theme.textTheme.displayMedium),
              if (statusLine != null) ...[
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: activeSession != null ? c.violet : c.violetLight,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(statusLine, style: theme.textTheme.bodyMedium?.copyWith(color: c.textSecondary)),
                  ],
                ),
              ],
              const Spacer(flex: 2),
              LiftPrimaryButton(
                label: activeSession != null ? l10n.homeResumeWorkout : l10n.homeStartFreestyleWorkout,
                icon: activeSession != null ? Icons.play_arrow_rounded : Icons.add_rounded,
                onPressed: () => context.push('/active-workout'),
              ),
              if (activeSession == null && splits != null && splits.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => context.push('/splits'),
                    icon: const Icon(Icons.calendar_view_week_outlined),
                    label: Text(l10n.homeStartFromSplit),
                  ),
                ),
              ],
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
