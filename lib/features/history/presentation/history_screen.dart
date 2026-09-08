import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../database/app_database.dart';
import '../providers/history_providers.dart';
import 'training_calendar.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  DateTime _dayOf(DateTime date) => DateTime(date.year, date.month, date.day);

  void _onDayTap(BuildContext context, List<WorkoutSession> sessions, DateTime day) {
    final matches = sessions.where((s) => _dayOf(s.startedAt) == day).toList();
    if (matches.isEmpty) return;
    if (matches.length == 1) {
      context.push('/history/session/${matches.first.id}');
      return;
    }
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: matches
              .map((session) => ListTile(
                    title: Text(_formatDate(session.startedAt)),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push('/history/session/${session.id}');
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(pastSessionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: sessionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (sessions) {
          final workoutDays = sessions.map((s) => _dayOf(s.startedAt)).toSet();

          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: TrainingCalendar(
                  workoutDays: workoutDays,
                  onDayTap: (day) => _onDayTap(context, sessions, day),
                ),
              ),
              const Divider(height: 1),
              if (sessions.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: Text('No workouts yet')),
                )
              else
                ...sessions.map((session) {
                  final duration = session.endedAt!.difference(session.startedAt);
                  return ListTile(
                    title: Text(_formatDate(session.startedAt)),
                    subtitle: Text('${duration.inMinutes} min'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/history/session/${session.id}'),
                  );
                }),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
