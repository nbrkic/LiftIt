import 'package:drift/drift.dart';
import '../app_database.dart';

extension ProgressPhotoQueries on AppDatabase {
  Stream<List<ProgressPhoto>> watchProgressPhotos() {
    return (select(progressPhotos)..orderBy([(p) => OrderingTerm.desc(p.takenAt)])).watch();
  }

  Future<int> insertProgressPhoto({
    required Uint8List imageBytes,
    String? notes,
  }) {
    return into(progressPhotos).insert(ProgressPhotosCompanion.insert(
      imageBytes: imageBytes,
      takenAt: DateTime.now(),
      notes: Value(notes),
    ));
  }

  Future<void> deleteProgressPhoto(int id) =>
      (delete(progressPhotos)..where((p) => p.id.equals(id))).go();

  Stream<ProgressPhoto?> watchProgressPhotoById(int id) {
    return (select(progressPhotos)..where((p) => p.id.equals(id))).watchSingleOrNull();
  }

  Future<void> setProgressPhotoSummary(int id, String summary) {
    return (update(progressPhotos)..where((p) => p.id.equals(id)))
        .write(ProgressPhotosCompanion(aiSummary: Value(summary)));
  }
}
