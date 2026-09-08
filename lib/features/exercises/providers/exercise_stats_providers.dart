import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/app_database.dart';
import '../../../database/queries/stats_queries.dart';
import '../../../providers/database_provider.dart';

final exerciseSetsProvider = StreamProvider.family<List<WorkoutSet>, int>((ref, exerciseId) {
  return ref.watch(appDatabaseProvider).watchSetsForExercise(exerciseId);
});
