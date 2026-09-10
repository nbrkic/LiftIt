import 'package:drift/drift.dart';
import '../app_database.dart';

extension RestDayQueries on AppDatabase {
  Stream<List<RestDay>> watchAllRestDays() => select(restDays).watch();

  Future<void> markRestDay(DateTime date) {
    return into(restDays).insert(
      RestDaysCompanion.insert(date: date),
      mode: InsertMode.insertOrIgnore,
    );
  }
}
