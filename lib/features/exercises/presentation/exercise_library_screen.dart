import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../database/enums.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/exercise_providers.dart';
import 'add_exercise_sheet.dart';

class ExerciseLibraryScreen extends ConsumerStatefulWidget {
  const ExerciseLibraryScreen({super.key});

  @override
  ConsumerState<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends ConsumerState<ExerciseLibraryScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(exerciseListProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.exercisesTitle),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: l10n.searchExercises,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (value) => setState(() => _query = value.trim().toLowerCase()),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => const AddExerciseSheet(),
        ),
        child: const Icon(Icons.add),
      ),
      body: exercisesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text(l10n.errorMessage('$error'))),
        data: (exercises) {
          final filtered = _query.isEmpty
              ? exercises
              : exercises.where((e) => e.name.toLowerCase().contains(_query)).toList();

          if (filtered.isEmpty) {
            return Center(child: Text(l10n.noExercisesFound));
          }

          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final exercise = filtered[index];
              return ListTile(
                title: Text(exercise.name),
                subtitle: Text(l10n.exerciseSubtitle(
                  exercise.primaryMuscleGroup.label(context),
                  exercise.equipment.label(context),
                )),
                trailing: exercise.isCustom ? const Icon(Icons.person, size: 18) : null,
                onTap: () => context.push('/exercises/${exercise.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
