import 'package:drift/drift.dart';
import '../app_database.dart';
import '../enums.dart';

extension ProfileQueries on AppDatabase {
  Stream<UserProfile?> watchProfile() {
    return (select(userProfiles)..limit(1)).watchSingleOrNull();
  }

  Future<void> upsertProfile({
    String? name,
    DateTime? birthDate,
    Gender? gender,
    double? heightCm,
    ExperienceLevel? experienceLevel,
    TrainingGoal? primaryGoal,
    required WeightUnit preferredWeightUnit,
    int? weeklyTrainingGoal,
  }) async {
    final existing = await (select(userProfiles)..limit(1)).getSingleOrNull();
    final companion = UserProfilesCompanion(
      name: Value(name),
      birthDate: Value(birthDate),
      gender: Value(gender),
      heightCm: Value(heightCm),
      experienceLevel: Value(experienceLevel),
      primaryGoal: Value(primaryGoal),
      preferredWeightUnit: Value(preferredWeightUnit),
      weeklyTrainingGoal: Value(weeklyTrainingGoal),
    );
    if (existing == null) {
      await into(userProfiles).insert(companion);
    } else {
      await (update(userProfiles)..where((p) => p.id.equals(existing.id))).write(companion);
    }
  }

  Stream<BodyweightLog?> watchLatestBodyweight() {
    return (select(bodyweightLogs)
          ..orderBy([(b) => OrderingTerm.desc(b.loggedAt)])
          ..limit(1))
        .watchSingleOrNull();
  }

  Stream<List<BodyweightLog>> watchBodyweightHistory() {
    return (select(bodyweightLogs)..orderBy([(b) => OrderingTerm.desc(b.loggedAt)])).watch();
  }

  Future<int> logBodyweight({required double weightKg, String? notes}) {
    return into(bodyweightLogs).insert(
      BodyweightLogsCompanion.insert(
        weightKg: weightKg,
        loggedAt: DateTime.now(),
        notes: Value(notes),
      ),
    );
  }

  Future<void> deleteBodyweightLog(int id) {
    return (delete(bodyweightLogs)..where((b) => b.id.equals(id))).go();
  }
}
