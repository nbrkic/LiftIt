import 'package:drift/drift.dart';

// Stored as a BLOB directly in SQLite, not as a file on disk — the app's
// backup/restore is a single VACUUM INTO of this database (see
// BackupService), and any new Drift table is automatically included in it
// with zero extra wiring. Files on disk would need a whole separate
// archive-based backup format instead of "just working" like every other
// table. Kept at full, uncompressed resolution (unlike the Gemini
// recognition flow) since these are for visual comparison over time, where
// quality matters more than the extra SQLite storage it costs.
class ProgressPhotos extends Table {
  IntColumn get id => integer().autoIncrement()();
  BlobColumn get imageBytes => blob()();
  DateTimeColumn get takenAt => dateTime()();
  TextColumn get notes => text().nullable()();
  // Gemini's comparison against the previous photo, filled in the
  // background right after this one is added (same fire-and-forget
  // pattern as WorkoutSessions.aiSummary) — null for the very first photo
  // (nothing to compare to), no key set, or a failed call.
  TextColumn get aiSummary => text().nullable()();
}
