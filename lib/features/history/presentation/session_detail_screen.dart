import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/weight_format.dart';
import '../../profile/providers/profile_providers.dart';
import '../providers/history_providers.dart';

class SessionDetailScreen extends ConsumerWidget {
  final int sessionId;

  const SessionDetailScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setsAsync = ref.watch(sessionDetailProvider(sessionId));
    final unit = ref.watch(preferredWeightUnitProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Workout Detail')),
      body: setsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (sets) {
          if (sets.isEmpty) {
            return const Center(child: Text('No sets logged'));
          }
          return ListView.builder(
            itemCount: sets.length,
            itemBuilder: (context, index) {
              final entry = sets[index];
              return ListTile(
                title: Text(entry.exercise.name),
                subtitle: Text(
                  'Set ${entry.set.setNumber} • ${formatWeight(entry.set.weight, unit)} × ${entry.set.reps}'
                  '${entry.set.rpe != null ? ' @ RPE ${entry.set.rpe}' : ''}'
                  '${entry.set.isWarmup ? ' • warm-up' : ''}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
