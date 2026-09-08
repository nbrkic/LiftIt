import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/app_database.dart';
import '../../../database/queries/workout_queries.dart';
import '../../../providers/database_provider.dart';
import '../providers/active_workout_providers.dart';
import 'exercise_picker_sheet.dart';
import 'log_set_sheet.dart';

class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  ConsumerState<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
  int? _sessionId;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final db = ref.read(appDatabaseProvider);
    final existing = await db.watchActiveSession().first;
    final id = existing?.id ?? await ref.read(activeWorkoutControllerProvider).startWorkout();
    if (mounted) setState(() => _sessionId = id);
  }

  Future<void> _addSet() async {
    final exercise = await showModalBottomSheet<Exercise>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const ExercisePickerSheet(),
    );
    if (exercise == null || !mounted) return;

    final currentSets = ref.read(activeSessionSetsProvider).value ?? [];
    final nextSetNumber =
        currentSets.where((s) => s.exercise.id == exercise.id).length + 1;

    if (!mounted) return;
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
          if (sets.isEmpty) {
            return const Center(child: Text('No sets logged yet — tap "Log Set" to start.'));
          }
          return ListView.builder(
            itemCount: sets.length,
            itemBuilder: (context, index) {
              final entry = sets[index];
              return ListTile(
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
              );
            },
          );
        },
      ),
    );
  }
}
