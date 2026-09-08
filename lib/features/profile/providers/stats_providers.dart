import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/queries/stats_queries.dart';
import '../../../providers/database_provider.dart';

final sessionVolumesProvider = StreamProvider<List<SessionVolume>>((ref) {
  return ref.watch(appDatabaseProvider).watchSessionVolumes();
});
