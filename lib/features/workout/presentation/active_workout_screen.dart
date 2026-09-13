import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/weight_format.dart';
import '../../../database/app_database.dart';
import '../../../database/enums.dart';
import '../../../database/queries/split_queries.dart';
import '../../../database/queries/workout_queries.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_motion.dart';
import '../../../design/tokens/app_radius.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/set_row.dart';
import '../../../design/widgets/stat_block.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/api_keys_provider.dart';
import '../../../providers/database_provider.dart';
import '../../exercises/providers/exercise_stats_providers.dart';
import '../../exercises/utils/exercise_stats.dart';
import '../../profile/providers/profile_providers.dart';
import '../../splits/providers/split_providers.dart';
import '../providers/active_workout_providers.dart';
import 'exercise_picker_sheet.dart';
import 'log_set_sheet.dart';
import 'workout_completion_view.dart';

class _ExerciseGroup {
  final Exercise exercise;
  final SplitDayExercise? planned;
  final List<WorkoutSet> sets = [];
  _ExerciseGroup({required this.exercise, this.planned});
}

class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  final int? startFromSplitDayId;

  const ActiveWorkoutScreen({super.key, this.startFromSplitDayId});

  @override
  ConsumerState<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
  int? _sessionId;
  int? _splitDayId;
  Timer? _tickTimer;
  DateTime? _lastSetLoggedAt;
  int? _justLoggedSetId;
  bool _showRest = false;
  bool _completed = false;
  List<FinishedGroup>? _finishedGroups;
  Duration _finishedDuration = Duration.zero;
  double _finishedVolume = 0;

  @override
  void initState() {
    super.initState();
    _init();
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    super.dispose();
  }

  Future<void> _init() async {
    final db = ref.read(appDatabaseProvider);
    final existing = await db.watchActiveSession().first;
    final id = existing?.id ??
        await ref.read(activeWorkoutControllerProvider).startWorkout(splitDayId: widget.startFromSplitDayId);
    if (mounted) {
      setState(() {
        _sessionId = id;
        _splitDayId = existing?.splitDayId ?? widget.startFromSplitDayId;
      });
    }
  }

  Future<void> _logSetFor(Exercise exercise) async {
    final currentSets = ref.read(activeSessionSetsProvider).value ?? [];
    final nextSetNumber = currentSets.where((s) => s.exercise.id == exercise.id).length + 1;
    final loggedSetId = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (_) => LogSetSheet(
        exercise: exercise,
        sessionId: _sessionId!,
        nextSetNumber: nextSetNumber,
      ),
    );
    if (loggedSetId != null) {
      HapticFeedback.lightImpact();
      setState(() {
        _lastSetLoggedAt = DateTime.now();
        _justLoggedSetId = loggedSetId;
        _showRest = true;
      });
    }
  }

  Future<void> _addNewExercise() async {
    final exercise = await showModalBottomSheet<Exercise>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const ExercisePickerSheet(),
    );
    if (exercise == null || !mounted) return;
    await _logSetFor(exercise);
  }

  Future<void> _finish() async {
    final sets = ref.read(activeSessionSetsProvider).value ?? [];
    final session = ref.read(activeSessionProvider).value;
    final plannedAsync =
        _splitDayId != null ? ref.read(splitDayExercisesProvider(_splitDayId!)) : null;
    final groups = _buildGroups(plannedAsync?.value, sets);
    final duration =
        session != null ? DateTime.now().difference(session.startedAt) : Duration.zero;
    final volume =
        sets.where((s) => !s.set.isWarmup).fold(0.0, (sum, s) => sum + s.set.weight * s.set.reps);

    final hasPr = groups.any((g) {
      final allSets = ref.read(exerciseSetsProvider(g.exercise.id)).value;
      final best = allSets != null ? computeOneRepMax(allSets) : null;
      if (best == null) return false;
      return g.sets.map((s) => s.id).contains(best.set.id);
    });

    await ref.read(activeWorkoutControllerProvider).finishWorkout(_sessionId!);
    hasPr ? HapticFeedback.heavyImpact() : HapticFeedback.mediumImpact();
    if (!mounted) return;

    final apiKey = (await ref.read(apiKeysProvider.notifier).ensureGeminiApiKey()).trim();
    if (!mounted) return;
    if (apiKey.isNotEmpty) {
      final languageName = Localizations.localeOf(context).languageCode == 'sr' ? 'Serbian' : 'English';
      // Deliberately not awaited — generating the AI summary must never
      // hold up showing the completion screen. It finishes in the
      // background and lands on the session once ready (History watches
      // the session row reactively, so it just appears there).
      ref.read(activeWorkoutControllerProvider).generateAiSummary(
            sessionId: _sessionId!,
            apiKey: apiKey,
            languageName: languageName,
            hasPr: hasPr,
          );
    }

    setState(() {
      _completed = true;
      _finishedGroups = groups
          .map((g) => FinishedGroup(exercise: g.exercise, sets: g.sets))
          .toList();
      _finishedDuration = duration;
      _finishedVolume = volume;
    });
  }

  List<_ExerciseGroup> _buildGroups(
    List<SplitDayExerciseWithExercise>? planned,
    List<WorkoutSetWithExercise> sets,
  ) {
    final groups = <int, _ExerciseGroup>{};
    final order = <int>[];

    if (planned != null) {
      for (final p in planned) {
        groups[p.exercise.id] = _ExerciseGroup(exercise: p.exercise, planned: p.planned);
        order.add(p.exercise.id);
      }
    }
    for (final entry in sets) {
      groups.putIfAbsent(entry.exercise.id, () {
        order.add(entry.exercise.id);
        return _ExerciseGroup(exercise: entry.exercise);
      }).sets.add(entry.set);
    }
    return order.map((id) => groups[id]!).toList();
  }

  String _formatElapsed(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes % 60;
    final seconds = d.inSeconds % 60;
    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context)!;

    if (_completed) {
      return WorkoutCompletionView(
        sessionId: _sessionId!,
        duration: _finishedDuration,
        volume: _finishedVolume,
        groups: _finishedGroups!,
        onDone: () => context.go('/home'),
      );
    }

    if (_sessionId == null) {
      return Scaffold(
        backgroundColor: c.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final unit = ref.watch(preferredWeightUnitProvider);
    final session = ref.watch(activeSessionProvider).value;
    final setsAsync = ref.watch(activeSessionSetsProvider);
    final plannedAsync =
        _splitDayId != null ? ref.watch(splitDayExercisesProvider(_splitDayId!)) : null;
    final splitDayAsync =
        _splitDayId != null ? ref.watch(splitDayByIdProvider(_splitDayId!)) : null;

    final elapsed = session != null ? DateTime.now().difference(session.startedAt) : Duration.zero;
    final restElapsed =
        _lastSetLoggedAt != null ? DateTime.now().difference(_lastSetLoggedAt!) : null;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              title: splitDayAsync?.value?.name ?? l10n.activeWorkoutTitle,
              onClose: () => Navigator.of(context).pop(),
              onFinish: _finish,
            ),
            setsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (error, stack) => const SizedBox.shrink(),
              data: (sets) {
                final volume = sets
                    .where((s) => !s.set.isWarmup)
                    .fold(0.0, (sum, s) => sum + s.set.weight * s.set.reps);

                // Only meaningful when the workout follows a split day's
                // list — "completed" means every set the plan calls for
                // has been logged, matching the same X/Y sets-progress
                // count already shown per exercise card below.
                final planned = plannedAsync?.value;
                int? completedExercises;
                int? totalPlannedExercises;
                if (planned != null && planned.isNotEmpty) {
                  final loggedCountByExercise = <int, int>{};
                  for (final entry in sets) {
                    loggedCountByExercise[entry.exercise.id] =
                        (loggedCountByExercise[entry.exercise.id] ?? 0) + 1;
                  }
                  totalPlannedExercises = planned.length;
                  completedExercises = planned
                      .where((p) => (loggedCountByExercise[p.exercise.id] ?? 0) >= p.planned.targetSets)
                      .length;
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.lg),
                  child: Row(
                    children: [
                      StatBlock(value: _formatElapsed(elapsed), label: l10n.minutesLabel, valueSize: 26),
                      const SizedBox(width: AppSpacing.xxxl),
                      StatBlock(
                        value: formatWeight(volume, unit, decimals: 0),
                        label: l10n.volumeLabel,
                        valueSize: 26,
                      ),
                      if (totalPlannedExercises != null) ...[
                        const SizedBox(width: AppSpacing.xxxl),
                        StatBlock(
                          value: '$completedExercises/$totalPlannedExercises',
                          label: l10n.exercisesCompletedLabel,
                          valueSize: 26,
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
            if (restElapsed != null && _showRest)
              _RestOverlay(
                elapsed: _formatElapsed(restElapsed),
                onDismiss: () => setState(() => _showRest = false),
              ),
            Divider(height: 1, color: c.divider),
            Expanded(
              child: setsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text(l10n.errorMessage('$error'))),
                data: (sets) {
                  final planned = plannedAsync?.value;
                  final groups = _buildGroups(planned, sets);

                  if (groups.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.noSetsLoggedTapAddExercise,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.sm,
                      AppSpacing.lg,
                      AppSpacing.massive,
                    ),
                    children: groups
                        .map((g) => _ExerciseGroupCard(
                              group: g,
                              sessionId: _sessionId!,
                              unit: unit,
                              justLoggedSetId: _justLoggedSetId,
                              onAddSet: () => _logSetFor(g.exercise),
                            ))
                        .toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewExercise,
        backgroundColor: c.violet,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(l10n.addExerciseFabLabel),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final VoidCallback onClose;
  final VoidCallback onFinish;

  const _Header({required this.title, required this.onClose, required this.onFinish});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.md, AppSpacing.lg, 0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.close_rounded, color: c.textSecondary),
            onPressed: onClose,
          ),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(onPressed: onFinish, child: Text(l10n.finishButton)),
        ],
      ),
    );
  }
}

class _RestOverlay extends StatelessWidget {
  final String elapsed;
  final VoidCallback onDismiss;

  const _RestOverlay({required this.elapsed, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context)!;
    return AnimatedContainer(
      duration: AppMotion.base,
      curve: AppMotion.enter,
      margin: const EdgeInsets.fromLTRB(AppSpacing.xxl, 0, AppSpacing.xxl, AppSpacing.lg),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: c.violet.withValues(alpha: 0.14),
        borderRadius: AppRadius.smRadius,
        border: Border.all(color: c.violet.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.timer_outlined, color: c.violet, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'REST',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: c.violet),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            elapsed,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: c.textPrimary),
          ),
          const Spacer(),
          TextButton(
            onPressed: onDismiss,
            child: Text(l10n.restDismiss, style: TextStyle(color: c.textSecondary)),
          ),
        ],
      ),
    );
  }
}

class _ExerciseGroupCard extends ConsumerWidget {
  final _ExerciseGroup group;
  final int sessionId;
  final WeightUnit unit;
  final int? justLoggedSetId;
  final VoidCallback onAddSet;

  const _ExerciseGroupCard({
    required this.group,
    required this.sessionId,
    required this.unit,
    required this.justLoggedSetId,
    required this.onAddSet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final repsRange = group.planned?.targetRepsLow != null && group.planned?.targetRepsHigh != null
        ? l10n.repsRange(group.planned!.targetRepsLow!, group.planned!.targetRepsHigh!)
        : null;

    final historyAsync = ref.watch(exerciseSetsProvider(group.exercise.id));
    final previous = historyAsync.value != null
        ? previousSessionSets(historyAsync.value!, sessionId)
        : const <WorkoutSet>[];

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(color: c.surface, borderRadius: AppRadius.mdRadius),
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.sm, AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(group.exercise.name, style: theme.textTheme.titleMedium),
                    if (group.planned != null)
                      Text(
                        l10n.setsProgress(group.sets.length, group.planned!.targetSets) +
                            (repsRange != null ? ' • $repsRange' : ''),
                        style: theme.textTheme.bodySmall,
                      )
                    else if (group.sets.isNotEmpty)
                      Text(l10n.setsCount(group.sets.length), style: theme.textTheme.bodySmall),
                    if (previous.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          '${l10n.lastTimeLabel}: ${previous.map((s) => '${formatWeight(s.weight, unit)}×${s.reps}').join(', ')}',
                          style: theme.textTheme.bodySmall?.copyWith(color: c.violetLight),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline, color: c.violet),
                onPressed: onAddSet,
              ),
            ],
          ),
          if (group.sets.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            ...group.sets.map(
              (set) => SetRow(
                setNumber: set.setNumber,
                weightLabel: formatWeight(set.weight, unit),
                reps: set.reps,
                rpe: set.rpe,
                note: set.notes,
                isWarmup: set.isWarmup,
                justLogged: set.id == justLoggedSetId,
                onDelete: () => ref.read(activeWorkoutControllerProvider).deleteSet(set.id),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
