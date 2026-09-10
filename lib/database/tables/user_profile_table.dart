import 'package:drift/drift.dart';
import '../enums.dart';

// Single-row table: this is a local, single-user app with no auth, so there
// is at most one UserProfile row ever. No userId FKs anywhere else either.
class UserProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().nullable()();
  DateTimeColumn get birthDate => dateTime().nullable()();
  TextColumn get gender => textEnum<Gender>().nullable()();
  RealColumn get heightCm => real().nullable()();
  TextColumn get experienceLevel => textEnum<ExperienceLevel>().nullable()();
  TextColumn get primaryGoal => textEnum<TrainingGoal>().nullable()();
  TextColumn get preferredWeightUnit =>
      textEnum<WeightUnit>().withDefault(const Constant('kg'))();
  IntColumn get weeklyTrainingGoal => integer().nullable()();
  IntColumn get dailyCalorieGoal => integer().nullable()();
  IntColumn get dailyProteinGoalG => integer().nullable()();
  IntColumn get dailyCarbsGoalG => integer().nullable()();
  IntColumn get dailyFatGoalG => integer().nullable()();
}
