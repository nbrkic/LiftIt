import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../database/app_database.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/empty_state.dart';
import '../../../design/widgets/progress_spine.dart';
import '../../../l10n/app_localizations.dart';
import '../../splits/providers/split_providers.dart';
import '../providers/history_providers.dart';
import 'training_calendar.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  DateTime _dayOf(DateTime date) => DateTime(date.year, date.month, date.day);

  Future<bool> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteWorkoutDialogTitle),
        content: Text(l10n.deleteWorkoutDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.deleteButton),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  String _sessionTitle(BuildContext context, WidgetRef ref, WorkoutSession session) {
    final l10n = AppLocalizations.of(context)!;
    if (session.splitDayId == null) return l10n.freestyle;
    final day = ref.watch(splitDayByIdProvider(session.splitDayId!)).value;
    return day?.name ?? l10n.freestyle;
  }

  void _onDayTap(
    BuildContext context,
    WidgetRef ref,
    List<WorkoutSession> sessions,
    DateTime day,
  ) {
    final matches = sessions.where((s) => _dayOf(s.startedAt) == day).toList();
    if (matches.isEmpty) return;
    if (matches.length == 1) {
      context.push('/history/session/${matches.first.id}');
      return;
    }
    final c = context.colors;
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.md),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: matches.length,
            separatorBuilder: (_, _) => Divider(height: 1, color: c.divider),
            itemBuilder: (context, index) {
              final session = matches[index];
              return InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  context.push('/history/session/${session.id}');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_sessionTitle(context, ref, session), style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text(_formatDate(session.startedAt),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.textSecondary)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final theme = Theme.of(context);
    final sessionsAsync = ref.watch(pastSessionsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.historyTitle),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      body: sessionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text(l10n.errorMessage('$error'))),
        data: (sessions) {
          final workoutDays = sessions.map((s) => _dayOf(s.startedAt)).toSet();

          return ListView(
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xxl, AppSpacing.md, AppSpacing.xxl, AppSpacing.sm),
                child: TrainingCalendar(
                  workoutDays: workoutDays,
                  onDayTap: (day) => _onDayTap(context, ref, sessions, day),
                ),
              ),
              Divider(height: 1, color: c.divider),
              if (sessions.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.xxxl),
                  child: LiftEmptyState(message: l10n.noWorkoutsYet),
                )
              else
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.xxl, AppSpacing.xl, AppSpacing.xxl, 0),
                  child: ProgressSpine(
                    children: sessions.map((session) {
                      final duration = session.endedAt!.difference(session.startedAt);
                      return Dismissible(
                        key: ValueKey(session.id),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (_) => _confirmDelete(context),
                        onDismissed: (_) =>
                            ref.read(historyControllerProvider).deleteSession(session.id),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: AppSpacing.lg),
                          margin: const EdgeInsets.only(bottom: AppSpacing.xl),
                          color: c.danger.withValues(alpha: 0.15),
                          child: Icon(Icons.delete_outline, color: c.danger),
                        ),
                        child: InkWell(
                          onTap: () => context.push('/history/session/${session.id}'),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _sessionTitle(context, ref, session),
                                        style: theme.textTheme.titleMedium,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        l10n.historyRowSubtitle(
                                            _formatDate(session.startedAt), duration.inMinutes),
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(color: c.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right, size: 20, color: c.textSecondary),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
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
