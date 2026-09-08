import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../workout/providers/active_workout_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSession = ref.watch(activeSessionProvider).value;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton.icon(
              onPressed: () => context.push('/active-workout'),
              icon: Icon(activeSession != null ? Icons.play_arrow : Icons.add),
              label: Text(activeSession != null ? l10n.homeResumeWorkout : l10n.homeStartFreestyleWorkout),
            ),
            if (activeSession == null) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => context.push('/splits'),
                icon: const Icon(Icons.calendar_view_week_outlined),
                label: Text(l10n.homeStartFromSplit),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
