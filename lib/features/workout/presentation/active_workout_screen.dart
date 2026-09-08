import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/app_database.dart';
import '../../../database/queries/workout_queries.dart';
import '../../../providers/database_provider.dart';
import '../../splits/providers/split_providers.dart';
import '../providers/active_workout_providers.dart';
import 'exercise_picker_sheet.dart';
import 'log_set_sheet.dart';

class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  final int? startFromSplitDayId;

  const ActiveWorkoutScreen({super.key, this.startFromSplitDayId});

  @override
  ConsumerState<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
  int? _sessionId;
  int? _splitDayId;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final db = ref.read(appDatabaseProvider);
    final existing = await db.watchActiveSession().first;
    final id = existing?.id ??
        await ref.read(activeWorkoutControllerProvider).startWorkout(
              splitDayId: widget.startFromSplitDayId,
            );
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
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => LogSetSheet(
        exercise: exercise,
        sessionId: _sessionId!,
        nextSetNumber: nextSetNumber,
      ),
    );
  }

  Future<void> _addSet() async {
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

  @override
  Widget build(BuildContext context) {
    if (_sessionId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final setsAsync = ref.watch(activeSessionSetsProvider);
    final plannedAsync =
        _splitDayId != null ? ref.watch(splitDayExercisesProvider(_splitDayId!)) : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Workout'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(onPressed: _finish, child: const Text('Finish')),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addSet,
        icon: const Icon(Icons.add),
        label: const Text('Log Set'),
      ),
      body: setsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (sets) {
          return ListView(
            children: [
              if (plannedAsync != null)
                plannedAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (error, stack) => const SizedBox.shrink(),
                  data: (planned) {
                    if (planned.isEmpty) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                          child: Text('Planned', style: Theme.of(context).textTheme.labelLarge),
                        ),
                        ...planned.map((entry) {
                          final loggedCount =
                              sets.where((s) => s.exercise.id == entry.exercise.id).length;
                          final repsRange = entry.planned.targetRepsLow != null &&
                                  entry.planned.targetRepsHigh != null
                              ? '${entry.planned.targetRepsLow}-${entry.planned.targetRepsHigh} reps'
                              : 'reps not set';
                          return ListTile(
                            title: Text(entry.exercise.name),
                            subtitle: Text(
                              '$loggedCount / ${entry.planned.targetSets} sets logged • $repsRange',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () => _logSetFor(entry.exercise),
                            ),
                          );
                        }),
                        const Divider(),
                      ],
                    );
                  },
                ),
              if (sets.isEmpty && (plannedAsync == null))
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: Text('No sets logged yet — tap "Log Set" to start.')),
                ),
              if (sets.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text('Logged Sets', style: Theme.of(context).textTheme.labelLarge),
                ),
              ...sets.map((entry) => ListTile(
                    title: Text(entry.exercise.name),
                    subtitle: Text(
                      'Set ${entry.set.setNumber} • ${entry.set.weight} kg × ${entry.set.reps}'
                      '${entry.set.isWarmup ? ' • warm-up' : ''}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () =>
                          ref.read(activeWorkoutControllerProvider).deleteSet(entry.set.id),
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }
}
