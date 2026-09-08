import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'app_database.dart';

const _dbName = 'liftit_db';

class BackupService {
  final AppDatabase _db;
  BackupService(this._db);

  // VACUUM INTO produces a single consistent snapshot file even while the
  // live connection stays open (handles any pending WAL data correctly),
  // so no need to close/reopen the app's database for export.
  Future<File> exportBackup() async {
    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final backupPath = p.join(tempDir.path, 'liftit_backup_$timestamp.sqlite');
    await _db.customStatement("VACUUM INTO '$backupPath'");
    return File(backupPath);
  }

  static Future<File> _liveDatabaseFile() async {
    final docsDir = await getApplicationDocumentsDirectory();
    return File(p.join(docsDir.path, '$_dbName.sqlite'));
  }

  // Overwrites the live database file with a previously exported backup.
  // Must be called with the AppDatabase already closed by the caller — the
  // app needs a full restart afterward to reopen a clean connection against
  // the replaced file.
  static Future<void> restoreFromFile(File backupFile) async {
    final liveFile = await _liveDatabaseFile();
    await backupFile.copy(liveFile.path);

    // Stale WAL/SHM sidecar files from the previous session must not survive
    // next to the freshly-restored (plain, non-WAL) file.
    for (final suffix in ['-wal', '-shm']) {
      final sidecar = File('${liveFile.path}$suffix');
      if (await sidecar.exists()) await sidecar.delete();
    }
  }
}
