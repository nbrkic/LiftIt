import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/split_providers.dart';
import 'create_split_sheet.dart';

class SplitsListScreen extends ConsumerWidget {
  const SplitsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splitsAsync = ref.watch(splitListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Splits')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final id = await showModalBottomSheet<int>(
            context: context,
            isScrollControlled: true,
            builder: (_) => const CreateSplitSheet(),
          );
          if (id != null && context.mounted) context.push('/splits/$id');
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        top: false,
        child: splitsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (splitList) {
            if (splitList.isEmpty) {
              return const Center(
                child: Text('No splits yet — tap + to create one.'),
              );
            }
            return ListView.builder(
              itemCount: splitList.length,
              itemBuilder: (context, index) {
                final split = splitList[index];
                return Dismissible(
                  key: ValueKey(split.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Theme.of(context).colorScheme.errorContainer,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete_outline),
                  ),
                  onDismissed: (_) =>
                      ref.read(splitControllerProvider).deleteSplit(split.id),
                  child: ListTile(
                    title: Text(split.name),
                    subtitle: split.description != null
                        ? Text(split.description!)
                        : null,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/splits/${split.id}'),
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
