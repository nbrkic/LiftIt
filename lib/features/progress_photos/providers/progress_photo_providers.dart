import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/app_database.dart';
import '../../../database/queries/progress_photo_queries.dart';
import '../../../providers/database_provider.dart';
import '../../nutrition/services/gemini_service.dart';
import '../services/progress_photo_summary_prompt.dart';

final progressPhotosProvider = StreamProvider<List<ProgressPhoto>>((ref) {
  return ref.watch(appDatabaseProvider).watchProgressPhotos();
});

final progressPhotoByIdProvider = StreamProvider.family.autoDispose<ProgressPhoto?, int>((ref, id) {
  return ref.watch(appDatabaseProvider).watchProgressPhotoById(id);
});

class ProgressPhotoController {
  final AppDatabase _db;
  ProgressPhotoController(this._db);

  Future<int> addPhoto({required Uint8List imageBytes, String? notes}) {
    return _db.insertProgressPhoto(imageBytes: imageBytes, notes: notes);
  }

  Future<void> deletePhoto(int id) => _db.deleteProgressPhoto(id);

  // Fire-and-forget from the caller's side, same as the workout AI summary
  // — called without `await` right after a photo is added, never holds up
  // the UI. Skips silently (no summary) if this is the first photo ever
  // (nothing to compare to) or if the call fails for any reason.
  Future<void> generateComparisonSummary({
    required int newPhotoId,
    required Uint8List newPhotoBytes,
    required String apiKey,
    required String languageName,
  }) async {
    try {
      final photos = await _db.watchProgressPhotos().first;
      final previous = photos.where((p) => p.id != newPhotoId).firstOrNull;
      if (previous == null) return;

      final prompt = buildProgressPhotoComparisonPrompt(languageName: languageName);
      final summary = await GeminiService().generateTextWithImages(
        prompt,
        [Uint8List.fromList(previous.imageBytes), newPhotoBytes],
        apiKey,
      );
      await _db.setProgressPhotoSummary(newPhotoId, summary);
    } catch (e) {
      debugPrint('[ProgressPhoto] failed to generate comparison for photo $newPhotoId: $e');
    }
  }
}

final progressPhotoControllerProvider = Provider<ProgressPhotoController>((ref) {
  return ProgressPhotoController(ref.watch(appDatabaseProvider));
});
