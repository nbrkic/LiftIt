import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/app_database.dart';
import '../../../database/queries/food_log_queries.dart';
import '../../../providers/database_provider.dart';

final allFoodLogEntriesProvider = StreamProvider<List<FoodLogEntry>>((ref) {
  return ref.watch(appDatabaseProvider).watchAllFoodLogEntries();
});
