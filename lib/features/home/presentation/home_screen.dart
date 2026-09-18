import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/lift_button.dart';
import '../../../design/widgets/streak_flame.dart';
import '../../../l10n/app_localizations.dart';
import '../../history/providers/history_providers.dart';
import '../../profile/providers/profile_providers.dart';
import '../../splits/providers/split_providers.dart';
import '../../streaks/providers/rest_day_providers.dart';
import '../../streaks/utils/streak_calculator.dart';
import '../../workout/providers/active_workout_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _greeting(AppLocalizations l10n, String? name) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? l10n.greetingMorning
        : hour < 18
            ? l10n.greetingAfternoon
            : l10n.greetingEvening;
    if (name == null || name.isEmpty) return greeting;
    return '$greeting, $name';
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  // Deterministic per calendar day so the message stays stable across
  // rebuilds/reopens today, but naturally varies (and resets) day to day.
  String _pickOfTheDay(List<String> pool) {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    return pool[dayOfYear % pool.length];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final activeSession = ref.watch(activeSessionProvider).value;
    final pastSessions = ref.watch(pastSessionsProvider).value;
    final splits = ref.watch(splitListProvider).value;
    final profile = ref.watch(userProfileProvider).value;
    final restDays = ref.watch(restDaysProvider).value ?? const [];
    final isRestDayToday = ref.watch(isRestDayTodayProvider);

    final hasWorkoutToday = pastSessions?.any((s) => _isToday(s.startedAt)) ?? false;
    final streakDays = computeDailyStreak(pastSessions ?? const [], restDays);
    final streakTier = currentStreakLevel(streakDays)?.tier ?? 0;

    String dayMessage;
    Color dotColor;
    if (activeSession != null) {
      dayMessage = l10n.workoutInProgressLabel;
      dotColor = c.violet;
    } else if (hasWorkoutToday) {
      dayMessage = _pickOfTheDay([
        l10n.homeCompletedMsg1,
        l10n.homeCompletedMsg2,
        l10n.homeCompletedMsg3,
        l10n.homeCompletedMsg4,
        l10n.homeCompletedMsg5,
        l10n.homeCompletedMsg6,
        l10n.homeCompletedMsg7,
        l10n.homeCompletedMsg8,
      ]);
      dotColor = c.violet;
    } else if (isRestDayToday) {
      dayMessage = _pickOfTheDay([
        l10n.homeRestMsg1,
        l10n.homeRestMsg2,
        l10n.homeRestMsg3,
        l10n.homeRestMsg4,
        l10n.homeRestMsg5,
        l10n.homeRestMsg6,
        l10n.homeRestMsg7,
        l10n.homeRestMsg8,
      ]);
      dotColor = c.textSecondary;
    } else {
      dayMessage = _pickOfTheDay([
        l10n.homeTodoMsg1,
        l10n.homeTodoMsg2,
        l10n.homeTodoMsg3,
        l10n.homeTodoMsg4,
        l10n.homeTodoMsg5,
        l10n.homeTodoMsg6,
        l10n.homeTodoMsg7,
        l10n.homeTodoMsg8,
      ]);
      dotColor = c.violetLight;
    }

    final showRestDayAction =
        activeSession == null && !hasWorkoutToday && !isRestDayToday;

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
              Text(_greeting(l10n, profile?.name), style: theme.textTheme.bodyLarge?.copyWith(color: c.textSecondary)),
              const SizedBox(height: AppSpacing.xs),
              Text(l10n.appTitle, style: theme.textTheme.displayMedium),
              const SizedBox(height: AppSpacing.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(dayMessage, style: theme.textTheme.bodyLarge?.copyWith(color: c.textSecondary)),
                  ),
                ],
              ),
              if (showRestDayAction)
                Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.lg),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => ref.read(restDayControllerProvider).markTodayAsRestDay(),
                    child: Text(l10n.homeMarkRestDayButton),
                  ),
                ),
              if (streakDays > 0) ...[
                const SizedBox(height: AppSpacing.lg),
                InkWell(
                  onTap: () => context.push('/streaks'),
                  child: Row(
                    children: [
                      StreakFlame(level: streakTier, size: 22),
                      const SizedBox(width: AppSpacing.sm),
                      Text(l10n.streakDaysCount(streakDays), style: theme.textTheme.bodyLarge),
                    ],
                  ),
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
