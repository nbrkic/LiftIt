import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../workout/providers/active_workout_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSession = ref.watch(activeSessionProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('LiftIt')),
      body: Center(
        child: FilledButton.icon(
          onPressed: () => context.push('/active-workout'),
          icon: Icon(activeSession != null ? Icons.play_arrow : Icons.add),
          label: Text(activeSession != null ? 'Resume Workout' : 'Start Workout'),
        ),
      ),
    );
  }
}
