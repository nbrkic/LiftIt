import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../database/app_database.dart';
import '../../workout/presentation/exercise_picker_sheet.dart';
import '../providers/split_providers.dart';
import 'target_sets_reps_sheet.dart';

class SplitDayDetailScreen extends ConsumerWidget {
  final int splitDayId;

  const SplitDayDetailScreen({super.key, required this.splitDayId});

  Future<void> _addExercise(BuildContext context, WidgetRef ref) async {
    final exercise = await showModalBottomSheet<Exercise>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const ExercisePickerSheet(),
    );
    if (exercise == null || !context.mounted) return;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          TargetSetsRepsSheet(exercise: exercise, splitDayId: splitDayId),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayAsync = ref.watch(splitDayByIdProvider(splitDayId));
    final plannedAsync = ref.watch(splitDayExercisesProvider(splitDayId));

    return Scaffold(
      appBar: AppBar(title: Text(dayAsync.value?.name ?? 'Day')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addExercise(context, ref),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        top: false,
        child: plannedAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (planned) {
            return Column(
              children: [
                Expanded(
                  child: planned.isEmpty
                      ? const Center(
                          child: Text('No exercises yet — tap + to add one.'),
                        )
                      : ListView.builder(
                          itemCount: planned.length,
                          itemBuilder: (context, index) {
                            final entry = planned[index];
                            final repsRange =
                                entry.planned.targetRepsLow != null &&
                                    entry.planned.targetRepsHigh != null
                                ? '${entry.planned.targetRepsLow}-${entry.planned.targetRepsHigh} reps'
                                : 'reps not set';
                            return Dismissible(
                              key: ValueKey(entry.planned.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Theme.of(context)
                                    .colorScheme
                                    .errorContainer,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: const Icon(Icons.delete_outline),
                              ),
                              onDismissed: (_) => ref
                                  .read(splitControllerProvider)
                                  .removeExerciseFromDay(entry.planned.id),
                              child: ListTile(
                                title: Text(entry.exercise.name),
                                subtitle: Text(
                                  '${entry.planned.targetSets} sets • $repsRange',
                                ),
                              ),
                            );
                          },
                        ),
                ),
                if (planned.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: FilledButton.icon(
                      onPressed: () =>
                          context.push('/active-workout', extra: splitDayId),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start Workout From This Day'),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
