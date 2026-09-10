import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/app_database.dart';
import '../../../database/enums.dart';
import '../../../database/queries/profile_queries.dart';
import '../../../providers/database_provider.dart';

final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  return ref.watch(appDatabaseProvider).watchProfile();
});

final latestBodyweightProvider = StreamProvider<BodyweightLog?>((ref) {
  return ref.watch(appDatabaseProvider).watchLatestBodyweight();
});

final bodyweightHistoryProvider = StreamProvider<List<BodyweightLog>>((ref) {
  return ref.watch(appDatabaseProvider).watchBodyweightHistory();
});

// Derived, synchronous convenience so widgets don't each need to unwrap
// userProfileProvider's AsyncValue just to read the unit preference.
final preferredWeightUnitProvider = Provider<WeightUnit>((ref) {
  return ref.watch(userProfileProvider).value?.preferredWeightUnit ?? WeightUnit.kg;
});

class ProfileController {
  final AppDatabase _db;
  ProfileController(this._db);

  Future<void> saveProfile({
    String? name,
    DateTime? birthDate,
    Gender? gender,
    double? heightCm,
    ExperienceLevel? experienceLevel,
    TrainingGoal? primaryGoal,
    required WeightUnit preferredWeightUnit,
    int? weeklyTrainingGoal,
    int? dailyCalorieGoal,
    int? dailyProteinGoalG,
    int? dailyCarbsGoalG,
    int? dailyFatGoalG,
    int? dailyWaterGoalMl,
  }) {
    return _db.upsertProfile(
      name: name,
      birthDate: birthDate,
      gender: gender,
      heightCm: heightCm,
      experienceLevel: experienceLevel,
      primaryGoal: primaryGoal,
      preferredWeightUnit: preferredWeightUnit,
      weeklyTrainingGoal: weeklyTrainingGoal,
      dailyCalorieGoal: dailyCalorieGoal,
      dailyProteinGoalG: dailyProteinGoalG,
      dailyCarbsGoalG: dailyCarbsGoalG,
      dailyFatGoalG: dailyFatGoalG,
      dailyWaterGoalMl: dailyWaterGoalMl,
    );
  }

  Future<int> logBodyweight({required double weightKg, String? notes}) {
    return _db.logBodyweight(weightKg: weightKg, notes: notes);
  }

  Future<void> deleteBodyweightLog(int id) => _db.deleteBodyweightLog(id);
}

final profileControllerProvider = Provider<ProfileController>((ref) {
  return ProfileController(ref.watch(appDatabaseProvider));
});
