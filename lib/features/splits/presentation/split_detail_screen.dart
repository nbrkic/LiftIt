import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/split_providers.dart';
import 'add_split_day_sheet.dart';

class SplitDetailScreen extends ConsumerWidget {
  final int splitId;

  const SplitDetailScreen({super.key, required this.splitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splitAsync = ref.watch(splitByIdProvider(splitId));
    final daysAsync = ref.watch(splitDaysProvider(splitId));

    return Scaffold(
      appBar: AppBar(title: Text(splitAsync.value?.name ?? 'Split')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => AddSplitDaySheet(splitId: splitId),
        ),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        top: false,
        child: daysAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (days) {
            if (days.isEmpty) {
              return const Center(
                child: Text('No days yet — tap + to add one.'),
              );
            }
            return ListView.builder(
              itemCount: days.length,
              itemBuilder: (context, index) {
                final day = days[index];
                return Dismissible(
                  key: ValueKey(day.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Theme.of(context).colorScheme.errorContainer,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete_outline),
                  ),
                  onDismissed: (_) =>
                      ref.read(splitControllerProvider).deleteDay(day.id),
                  child: ListTile(
                    title: Text(day.name),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/splits/$splitId/day/${day.id}'),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
