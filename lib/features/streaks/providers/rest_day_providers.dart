import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/app_database.dart';
import '../../../database/queries/rest_day_queries.dart';
import '../../../providers/database_provider.dart';

DateTime dayOf(DateTime date) => DateTime(date.year, date.month, date.day);

final restDaysProvider = StreamProvider<List<RestDay>>((ref) {
  return ref.watch(appDatabaseProvider).watchAllRestDays();
});

final isRestDayTodayProvider = Provider<bool>((ref) {
  final restDays = ref.watch(restDaysProvider).value ?? const [];
  final today = dayOf(DateTime.now());
  return restDays.any((r) => r.date == today);
});

class RestDayController {
  final AppDatabase _db;
  RestDayController(this._db);

  Future<void> markTodayAsRestDay() => _db.markRestDay(dayOf(DateTime.now()));
}

final restDayControllerProvider = Provider<RestDayController>((ref) {
  return RestDayController(ref.watch(appDatabaseProvider));
});
