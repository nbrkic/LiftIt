import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/weight_format.dart';
import '../../../database/app_database.dart';
import '../../../database/enums.dart';
import '../../../database/queries/split_queries.dart';
import '../../../database/queries/workout_queries.dart';
import '../../../providers/database_provider.dart';
import '../../profile/providers/profile_providers.dart';
import '../../splits/providers/split_providers.dart';
import '../providers/active_workout_providers.dart';
import 'exercise_picker_sheet.dart';
import 'log_set_sheet.dart';

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
  ConsumerState<ActiveWorkoutScreen> createState() =>
      _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
  int? _sessionId;
  int? _splitDayId;
  Timer? _tickTimer;
  DateTime? _lastSetLoggedAt;

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
    final id =
        existing?.id ??
        await ref
            .read(activeWorkoutControllerProvider)
            .startWorkout(splitDayId: widget.startFromSplitDayId);
    if (mounted) {
      setState(() {
        _sessionId = id;
        _splitDayId = existing?.splitDayId ?? widget.startFromSplitDayId;
      });
    }
  }

  Future<void> _logSetFor(Exercise exercise) async {
    final currentSets = ref.read(activeSessionSetsProvider).value ?? [];
    final nextSetNumber =
        currentSets.where((s) => s.exercise.id == exercise.id).length + 1;
    final logged = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => LogSetSheet(
        exercise: exercise,
        sessionId: _sessionId!,
        nextSetNumber: nextSetNumber,
      ),
    );
    if (logged == true) setState(() => _lastSetLoggedAt = DateTime.now());
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
    await ref.read(activeWorkoutControllerProvider).finishWorkout(_sessionId!);
    if (mounted) Navigator.of(context).pop();
  }

  List<_ExerciseGroup> _buildGroups(
    List<SplitDayExerciseWithExercise>? planned,
    List<WorkoutSetWithExercise> sets,
  ) {
    final groups = <int, _ExerciseGroup>{};
    final order = <int>[];

    if (planned != null) {
      for (final p in planned) {
        groups[p.exercise.id] = _ExerciseGroup(
          exercise: p.exercise,
          planned: p.planned,
        );
        order.add(p.exercise.id);
      }
    }
    for (final entry in sets) {
      groups
          .putIfAbsent(entry.exercise.id, () {
            order.add(entry.exercise.id);
            return _ExerciseGroup(exercise: entry.exercise);
          })
          .sets
          .add(entry.set);
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
    if (_sessionId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);
    final unit = ref.watch(preferredWeightUnitProvider);
    final session = ref.watch(activeSessionProvider).value;
    final setsAsync = ref.watch(activeSessionSetsProvider);
    final plannedAsync = _splitDayId != null
        ? ref.watch(splitDayExercisesProvider(_splitDayId!))
        : null;

    final elapsed = session != null
        ? DateTime.now().difference(session.startedAt)
        : Duration.zero;
    final restElapsed = _lastSetLoggedAt != null
        ? DateTime.now().difference(_lastSetLoggedAt!)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Workout'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [TextButton(onPressed: _finish, child: const Text('Finish'))],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewExercise,
        icon: const Icon(Icons.add),
        label: const Text('Add Exercise'),
      ),
      body: SafeArea(
        top: false,
        child: setsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (sets) {
            final volume = sets
                .where((s) => !s.set.isWarmup)
                .fold(0.0, (sum, s) => sum + s.set.weight * s.set.reps);

            final planned = plannedAsync?.value;
            final groups = _buildGroups(planned, sets);

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatChip(
                        icon: Icons.timer_outlined,
                        label: _formatElapsed(elapsed),
                      ),
                      _StatChip(
                        icon: Icons.fitness_center,
                        label: formatWeight(volume, unit, decimals: 0),
                      ),
                    ],
                  ),
                ),
                if (restElapsed != null) _buildRestBanner(theme, restElapsed),
                const Divider(height: 1),
                Expanded(
                  child: groups.isEmpty
                      ? const Center(
                          child: Text(
                            'No sets logged yet — tap "Add Exercise" to start.',
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          children: groups
                              .map((g) => _buildGroupCard(theme, unit, g))
                              .toList(),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRestBanner(ThemeData theme, Duration restElapsed) {
    return Container(
      color: theme.colorScheme.primaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.timer, color: theme.colorScheme.onPrimaryContainer),
          const SizedBox(width: 8),
          Text(
            'Rest: ${_formatElapsed(restElapsed)}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(
    ThemeData theme,
    WeightUnit unit,
    _ExerciseGroup group,
  ) {
    final repsRange =
        group.planned?.targetRepsLow != null &&
            group.planned?.targetRepsHigh != null
        ? '${group.planned!.targetRepsLow}-${group.planned!.targetRepsHigh} reps'
        : null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.exercise.name,
                        style: theme.textTheme.titleMedium,
                      ),
                      if (group.planned != null)
                        Text(
                          '${group.sets.length}/${group.planned!.targetSets} sets'
                          '${repsRange != null ? ' • $repsRange' : ''}',
                          style: theme.textTheme.bodySmall,
                        )
                      else if (group.sets.isNotEmpty)
                        Text(
                          '${group.sets.length} sets',
                          style: theme.textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => _logSetFor(group.exercise),
                ),
              ],
            ),
            ...group.sets.map(
              (set) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Set ${set.setNumber}  •  ${formatWeight(set.weight, unit)} × ${set.reps}'
                  '${set.rpe != null ? ' @ RPE ${set.rpe}' : ''}'
                  '${set.isWarmup ? ' (warm-up)' : ''}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: () => ref
                      .read(activeWorkoutControllerProvider)
                      .deleteSet(set.id),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
