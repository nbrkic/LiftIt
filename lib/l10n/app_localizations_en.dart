// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'LiftIt';

  @override
  String get navHome => 'Home';

  @override
  String get navHistory => 'History';

  @override
  String get navExercises => 'Exercises';

  @override
  String get navStats => 'Stats';

  @override
  String get navProfile => 'Profile';

  @override
  String get drawerSplits => 'Splits';

  @override
  String get drawerBodyweight => 'Bodyweight';

  @override
  String get drawerNutrition => 'Nutrition';

  @override
  String get drawerStreaks => 'Streaks';

  @override
  String get drawerBmiCalculator => 'BMI Calculator';

  @override
  String get drawerSettings => 'Settings';

  @override
  String errorMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get searchExercises => 'Search exercises';

  @override
  String get invalid => 'Invalid';

  @override
  String get enterAName => 'Enter a name';

  @override
  String get freestyle => 'Freestyle';

  @override
  String exerciseSubtitle(String muscleGroup, String equipment) {
    return '$muscleGroup • $equipment';
  }

  @override
  String weightLabelWithUnit(String unit) {
    return 'Weight ($unit)';
  }

  @override
  String timesReps(String weight, int reps) {
    return '$weight × $reps';
  }

  @override
  String rpeSuffix(String rpe) {
    return ' @ RPE $rpe';
  }

  @override
  String get warmupSuffix => ' (warm-up)';

  @override
  String repsRange(int low, int high) {
    return '$low-$high reps';
  }

  @override
  String get repsNotSet => 'reps not set';

  @override
  String get lastTimeLabel => 'Last time';

  @override
  String get newPrTag => 'New PR';

  @override
  String get restDismiss => 'Dismiss';

  @override
  String get setsLabel => 'Sets';

  @override
  String get workoutCompleteTitle => 'Workout Complete';

  @override
  String get doneButton => 'Done';

  @override
  String get deleteWorkoutDialogTitle => 'Delete workout?';

  @override
  String get deleteWorkoutDialogContent =>
      'This will permanently delete this workout and all its logged sets. This cannot be undone.';

  @override
  String get deleteButton => 'Delete';

  @override
  String get homeStartFreestyleWorkout => 'Start Freestyle Workout';

  @override
  String get homeResumeWorkout => 'Resume Workout';

  @override
  String get homeStartFromSplit => 'Start From a Split';

  @override
  String get workoutInProgressLabel => 'Workout in progress';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get homeCompletedMsg1 => 'Today\'s work is done. Recovery starts now.';

  @override
  String get homeCompletedMsg2 =>
      'Logged and locked in. That\'s today handled.';

  @override
  String get homeCompletedMsg3 => 'Another session banked. Consistency wins.';

  @override
  String get homeTodoMsg1 => 'No session logged yet today.';

  @override
  String get homeTodoMsg2 => 'Today\'s still open — get a session in.';

  @override
  String get homeTodoMsg3 => 'Nothing logged yet. The day\'s not over.';

  @override
  String get homeRestMsg1 => 'Rest day. Recovery is part of the work.';

  @override
  String get homeRestMsg2 => 'Taking it easy today. That\'s the plan.';

  @override
  String get homeRestMsg3 => 'Rest day noted. Come back stronger.';

  @override
  String get homeMarkRestDayButton => 'Today\'s a rest day';

  @override
  String get homeNoStreakYet => 'Train today to start a streak.';

  @override
  String get streaksTitle => 'Streaks';

  @override
  String streakDaysCount(int count) {
    return '$count day streak';
  }

  @override
  String streakDaysRequired(int count) {
    return '$count days';
  }

  @override
  String get streakLevel1Name => 'Spark';

  @override
  String get streakLevel2Name => 'Ember';

  @override
  String get streakLevel3Name => 'Flame';

  @override
  String get streakLevel4Name => 'Blaze';

  @override
  String get streakLevel5Name => 'Inferno';

  @override
  String get streakCurrentLevelLabel => 'Current';

  @override
  String get streakLockedLabel => 'Locked';

  @override
  String get streakAchievedLabel => 'Achieved';

  @override
  String get streakScreenIntro =>
      'Train (or mark a rest day) every day to build your streak. Miss a day and it resets.';

  @override
  String get nutritionTitle => 'Nutrition';

  @override
  String get nutritionTodayLabel => 'Today';

  @override
  String get nutritionCaloriesLabel => 'Calories';

  @override
  String get nutritionCaloriesUnitShort => 'cal';

  @override
  String get nutritionProteinLabel => 'Protein';

  @override
  String get nutritionCarbsLabel => 'Carbs';

  @override
  String get nutritionFatLabel => 'Fat';

  @override
  String get nutritionWaterLabel => 'Water';

  @override
  String get nutritionUndoWaterAction => 'Undo last';

  @override
  String get dailyWaterGoalLabel => 'Water goal (L)';

  @override
  String get nutritionSupplementsLabel => 'Supplements';

  @override
  String get nutritionManageSupplementsAction => 'Manage supplements';

  @override
  String get nutritionAddSupplementTitle => 'Add Supplement';

  @override
  String get nutritionSupplementNameLabel => 'Supplement name';

  @override
  String get nutritionSupplementDosageLabel => 'Daily amount (e.g. 5g)';

  @override
  String get nutritionSupplementsEmpty => 'No supplements added yet.';

  @override
  String get deleteSupplementDialogTitle => 'Delete supplement?';

  @override
  String get deleteSupplementDialogContent =>
      'This will permanently delete this supplement and its history.';

  @override
  String get nutritionEmptyDay => 'No food logged yet — tap + to add.';

  @override
  String get nutritionLogFoodTitle => 'Log Food';

  @override
  String get nutritionFoodNameLabel => 'Food name';

  @override
  String get nutritionQuantityLabel => 'Quantity (e.g. 150 g)';

  @override
  String get nutritionEntryModeTotal => 'Total amount';

  @override
  String get nutritionEntryModePer100g => 'Per 100 g';

  @override
  String get nutritionPer100gCaloriesLabel => 'Calories /100g';

  @override
  String get nutritionPer100gProteinLabel => 'Protein /100g';

  @override
  String get nutritionPer100gCarbsLabel => 'Carbs /100g';

  @override
  String get nutritionPer100gFatLabel => 'Fat /100g';

  @override
  String get nutritionCalculatedTotalLabel => 'Calculated total';

  @override
  String get nutritionSaveFoodOption => 'Save food';

  @override
  String get nutritionLogButton => 'Log';

  @override
  String get nutritionSourceOpenFoodFacts => 'Open Food Facts';

  @override
  String get nutritionSourceUsda => 'USDA';

  @override
  String get nutritionSourceGemini => 'Gemini';

  @override
  String get nutritionSourceManual => 'Manual';

  @override
  String get deleteFoodDialogTitle => 'Delete entry?';

  @override
  String get deleteFoodDialogContent =>
      'This will permanently delete this food log entry.';

  @override
  String get deleteSavedFoodDialogTitle => 'Delete saved food?';

  @override
  String get deleteSavedFoodDialogContent =>
      'This will permanently delete this saved food.';

  @override
  String get nutritionAddFoodTitle => 'Add Food';

  @override
  String get nutritionSearchOption => 'Search';

  @override
  String get nutritionManualOption => 'Enter Manually';

  @override
  String get nutritionLoadValuesOption => 'Load Values';

  @override
  String get nutritionSavedFoodTitle => 'Saved Food';

  @override
  String get nutritionSavedFoodEmpty => 'No saved food yet.';

  @override
  String get nutritionPer100gBadge => 'per 100 g';

  @override
  String get nutritionSearchFoodHint => 'Search food';

  @override
  String get nutritionSearchEmptyResults => 'No results found.';

  @override
  String get nutritionQuantityGramsLabel => 'Quantity (g)';

  @override
  String get apiKeysSectionLabel => 'API Keys';

  @override
  String get apiKeysDescription =>
      'Optional and free. Your own keys stay on this device and are used only to search USDA\'s food database and analyze food photos with Gemini.';

  @override
  String get geminiApiKeyLabel => 'Gemini API key';

  @override
  String get usdaApiKeyLabel => 'USDA API key';

  @override
  String get nutritionUsdaKeyMissingHint =>
      'Add a free USDA API key in Settings to also search generic foods, not just packaged products.';

  @override
  String get nutritionScanBarcodeOption => 'Scan Barcode';

  @override
  String get nutritionBarcodeNotFound =>
      'Product not found — you can still log it manually.';

  @override
  String get nutritionCameraPermissionDenied =>
      'Camera access is needed to scan barcodes. Enable it in system Settings > Apps > Lift It > Permissions.';

  @override
  String get nutritionScannerUnsupported =>
      'Barcode scanning isn\'t supported on this device.';

  @override
  String get nutritionPhotoOption => 'Photo';

  @override
  String get nutritionDescribeOption => 'Describe Food';

  @override
  String get nutritionAiProcessing =>
      'Analyzing… this can take up to a minute.';

  @override
  String get nutritionGeminiKeyMissing =>
      'Add a free Gemini API key in Settings to use photo recognition.';

  @override
  String get nutritionNoItemsRecognized =>
      'Couldn\'t recognize any food in that photo. Try again or enter manually.';

  @override
  String get nutritionPhotoResultsTitle => 'Recognized Items';

  @override
  String get nutritionDescribeFoodTitle => 'Describe the meal';

  @override
  String get nutritionDescribeFoodHint =>
      'e.g. 200g grilled chicken breast with rice, cooked in olive oil';

  @override
  String get nutritionEstimateButton => 'Estimate';

  @override
  String get nutritionTryAiEstimateAction => 'Try AI estimate';

  @override
  String get bodyweightTitle => 'Bodyweight';

  @override
  String get bodyweightLogWeighIn => 'Log Weigh-in';

  @override
  String get bodyweightNoWeighInsYet => 'No weigh-ins yet';

  @override
  String bodyweightCurrent(String weight) {
    return 'Current: $weight';
  }

  @override
  String get historyLabel => 'History';

  @override
  String get bodyweightNoWeighInsYetTapToLog =>
      'No weigh-ins yet — tap + to log one.';

  @override
  String bodyweightHistoryRow(String date, String notes) {
    return '$date • $notes';
  }

  @override
  String get addExerciseTitle => 'Add Custom Exercise';

  @override
  String get nameLabel => 'Name';

  @override
  String get muscleGroupLabel => 'Muscle group';

  @override
  String get equipmentLabel => 'Equipment';

  @override
  String get addExerciseButton => 'Add Exercise';

  @override
  String get exerciseFallbackTitle => 'Exercise';

  @override
  String get noSetsLoggedForExercise => 'No sets logged for this exercise yet.';

  @override
  String get personalRecord => 'Personal Record';

  @override
  String get oneRepMaxTested => '1RM (tested)';

  @override
  String get estimatedOneRepMax => 'Estimated 1RM';

  @override
  String get progressChartTitle => 'Progressive Overload';

  @override
  String get exercisesTitle => 'Exercises';

  @override
  String get noExercisesFound => 'No exercises found';

  @override
  String get historyTitle => 'History';

  @override
  String get noWorkoutsYet => 'No workouts yet';

  @override
  String historyRowSubtitle(String date, int minutes) {
    return '$date • $minutes min';
  }

  @override
  String get noSetsLogged => 'No sets logged';

  @override
  String get minutesLabel => 'minutes';

  @override
  String get volumeLabel => 'volume';

  @override
  String get exerciseLabelSingular => 'exercise';

  @override
  String get exerciseLabelPlural => 'exercises';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get dateOfBirthLabel => 'Date of birth';

  @override
  String get notSet => 'Not set';

  @override
  String get genderLabel => 'Gender';

  @override
  String get heightLabel => 'Height (cm)';

  @override
  String get experienceLevelLabel => 'Experience level';

  @override
  String get primaryGoalLabel => 'Primary goal';

  @override
  String get preferredWeightUnitLabel => 'Preferred weight unit';

  @override
  String get weeklyTrainingGoalLabel => 'Weekly training goal (days)';

  @override
  String get nutritionGoalsSectionLabel => 'Nutrition Goals';

  @override
  String get dailyCalorieGoalLabel => 'Daily calories';

  @override
  String get dailyProteinGoalLabel => 'Daily protein (g)';

  @override
  String get dailyCarbsGoalLabel => 'Daily carbs (g)';

  @override
  String get dailyFatGoalLabel => 'Daily fat (g)';

  @override
  String get saveButton => 'Save';

  @override
  String get logWeighInTitle => 'Log Weigh-in';

  @override
  String get notesOptionalLabel => 'Notes (optional)';

  @override
  String get logWeightButton => 'Log Weight';

  @override
  String get profileTitle => 'Profile';

  @override
  String get noNameSet => 'No name set';

  @override
  String ageLabel(int age) {
    return 'Age: $age';
  }

  @override
  String genderValueLabel(String gender) {
    return 'Gender: $gender';
  }

  @override
  String heightValueLabel(String height) {
    return 'Height: $height cm';
  }

  @override
  String experienceValueLabel(String level) {
    return 'Experience: $level';
  }

  @override
  String goalValueLabel(String goal) {
    return 'Goal: $goal';
  }

  @override
  String weeklyGoalValueLabel(int days) {
    return 'Weekly goal: $days days';
  }

  @override
  String preferredUnitValueLabel(String unit) {
    return 'Preferred unit: $unit';
  }

  @override
  String get tapEditToFillProfile =>
      'Tap the edit icon to fill in your profile.';

  @override
  String get basicInfoSectionLabel => 'Basic Info';

  @override
  String get editNutritionGoalsTitle => 'Edit Nutrition Goals';

  @override
  String get noNutritionGoalsSet => 'No nutrition goals set yet.';

  @override
  String dailyCalorieGoalValueLabel(int value) {
    return 'Calorie goal: $value cal';
  }

  @override
  String dailyProteinGoalValueLabel(int value) {
    return 'Protein goal: $value g';
  }

  @override
  String dailyCarbsGoalValueLabel(int value) {
    return 'Carbs goal: $value g';
  }

  @override
  String dailyFatGoalValueLabel(int value) {
    return 'Fat goal: $value g';
  }

  @override
  String dailyWaterGoalValueLabel(String value) {
    return 'Water goal: $value L';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get appearanceLabel => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get languageLabel => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSerbian => 'Serbian';

  @override
  String get backupRestoreLabel => 'Backup & Restore';

  @override
  String get backupDescription =>
      'All your data lives only on this device. Export a backup regularly so you never lose your training history.';

  @override
  String get exportBackupButton => 'Export Backup';

  @override
  String get restoreFromBackupButton => 'Restore from Backup';

  @override
  String get aboutLabel => 'About';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get aboutDescription =>
      'A free, no-nonsense gym tracker. All your data stays on this device.';

  @override
  String get backupShareText => 'LiftIt backup';

  @override
  String exportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String get selectBackupFileTitle => 'Select LiftIt backup file';

  @override
  String get restoreBackupDialogTitle => 'Restore backup?';

  @override
  String get restoreBackupDialogContent =>
      'This will replace all current data on this device with the backup. This cannot be undone.';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get restoreButton => 'Restore';

  @override
  String get restoreCompleteTitle => 'Restore complete';

  @override
  String get restoreCompleteContent =>
      'LiftIt will now close. Reopen the app to see your restored data.';

  @override
  String get closeAppButton => 'Close App';

  @override
  String get addDayTitle => 'Add Day';

  @override
  String get dayNameLabel => 'Day name (e.g. Push Day)';

  @override
  String get addDayButton => 'Add Day';

  @override
  String get createSplitTitle => 'Create Split';

  @override
  String get splitNameLabel => 'Name (e.g. Push Pull Legs)';

  @override
  String get descriptionOptionalLabel => 'Description (optional)';

  @override
  String get createButton => 'Create';

  @override
  String get noExercisesYetTapToAdd => 'No exercises yet — tap + to add one.';

  @override
  String setsRepsRangeSummary(int sets, String repsRange) {
    return '$sets sets • $repsRange';
  }

  @override
  String get startWorkoutFromThisDay => 'Start Workout From This Day';

  @override
  String get noDaysYetTapToAdd => 'No days yet — tap + to add one.';

  @override
  String get splitsTitle => 'Splits';

  @override
  String get noSplitsYetTapToCreate => 'No splits yet — tap + to create one.';

  @override
  String get targetSetsLabel => 'Target sets';

  @override
  String get repsFromOptionalLabel => 'Reps from (optional)';

  @override
  String get repsToOptionalLabel => 'Reps to (optional)';

  @override
  String get addToDayButton => 'Add to Day';

  @override
  String get statsTitle => 'Stats';

  @override
  String get finishWorkoutToSeeStats => 'Finish a workout to see stats here.';

  @override
  String get totalWorkouts => 'Total Workouts';

  @override
  String get currentStreak => 'Current Streak';

  @override
  String get avgPerWeek => 'Avg / Week';

  @override
  String get avgDuration => 'Avg Duration';

  @override
  String durationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get trainingVolumeWeekly => 'Training Volume (weekly)';

  @override
  String get noCompletedWorkoutsYet => 'No completed workouts yet';

  @override
  String get personalRecords => 'Personal Records';

  @override
  String get noSetsLoggedYet => 'No sets logged yet.';

  @override
  String get volumeByMuscleGroup => 'Volume by Muscle Group';

  @override
  String percentValue(String value) {
    return '$value%';
  }

  @override
  String get activeWorkoutTitle => 'Active Workout';

  @override
  String get finishButton => 'Finish';

  @override
  String get addExerciseFabLabel => 'Add Exercise';

  @override
  String get noSetsLoggedTapAddExercise =>
      'No sets logged yet — tap \"Add Exercise\" to start.';

  @override
  String restLabel(String elapsed) {
    return 'Rest: $elapsed';
  }

  @override
  String setsProgress(int logged, int target) {
    return '$logged/$target sets';
  }

  @override
  String setsCount(int count) {
    return '$count sets';
  }

  @override
  String setRowLabel(int number, String weight, int reps) {
    return 'Set $number  •  $weight × $reps';
  }

  @override
  String setNumberLabel(int number) {
    return 'Set $number';
  }

  @override
  String get repsLabel => 'Reps';

  @override
  String get rpeOptionalLabel => 'RPE (optional, 1-10)';

  @override
  String get rpeRangeError => '1-10';

  @override
  String get noteOptionalLabel => 'Note (optional)';

  @override
  String get warmupSetLabel => 'Warm-up set';

  @override
  String get logSetButton => 'Log Set';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderOther => 'Other';

  @override
  String get genderPreferNotToSay => 'Prefer not to say';

  @override
  String get experienceBeginner => 'Beginner';

  @override
  String get experienceIntermediate => 'Intermediate';

  @override
  String get experienceAdvanced => 'Advanced';

  @override
  String get goalStrength => 'Strength';

  @override
  String get goalHypertrophy => 'Hypertrophy';

  @override
  String get goalEndurance => 'Endurance';

  @override
  String get goalWeightLoss => 'Weight Loss';

  @override
  String get goalGeneralFitness => 'General Fitness';

  @override
  String get weightUnitKg => 'Kilograms (kg)';

  @override
  String get weightUnitLb => 'Pounds (lb)';

  @override
  String get muscleChest => 'Chest';

  @override
  String get muscleBack => 'Back';

  @override
  String get muscleShoulders => 'Shoulders';

  @override
  String get muscleBiceps => 'Biceps';

  @override
  String get muscleTriceps => 'Triceps';

  @override
  String get muscleLegs => 'Legs';

  @override
  String get muscleGlutes => 'Glutes';

  @override
  String get muscleCore => 'Core';

  @override
  String get muscleCalves => 'Calves';

  @override
  String get muscleForearms => 'Forearms';

  @override
  String get muscleFullBody => 'Full Body';

  @override
  String get muscleCardio => 'Cardio';

  @override
  String get equipmentBarbell => 'Barbell';

  @override
  String get equipmentDumbbell => 'Dumbbell';

  @override
  String get equipmentMachine => 'Machine';

  @override
  String get equipmentCable => 'Cable';

  @override
  String get equipmentBodyweight => 'Bodyweight';

  @override
  String get equipmentKettlebell => 'Kettlebell';

  @override
  String get equipmentBand => 'Band';

  @override
  String get equipmentOther => 'Other';

  @override
  String get bmiCalculatorTitle => 'BMI Calculator';

  @override
  String get bmiWeightLabel => 'Weight (kg)';

  @override
  String get bmiAgeLabel => 'Age';

  @override
  String get bmiActivityLevelLabel => 'Activity level';

  @override
  String get activityLevelSedentary => 'Sedentary (little or no exercise)';

  @override
  String get activityLevelLight => 'Lightly active (1-3 days/week)';

  @override
  String get activityLevelModerate => 'Moderately active (3-5 days/week)';

  @override
  String get activityLevelActive => 'Very active (6-7 days/week)';

  @override
  String get activityLevelVeryActive =>
      'Extra active (hard exercise + physical job)';

  @override
  String bmiResultLabel(String value) {
    return 'BMI: $value';
  }

  @override
  String get bmiCategoryUnderweight => 'Underweight';

  @override
  String get bmiCategoryNormal => 'Normal weight';

  @override
  String get bmiCategoryOverweight => 'Overweight';

  @override
  String get bmiCategoryObese => 'Obese';

  @override
  String get bmiMissingInputsHint => 'Enter weight and height to see your BMI.';

  @override
  String get bmiGoalsSectionLabel => 'Daily Calorie & Macro Goals';

  @override
  String get bmiGoalsMissingInputsHint =>
      'Enter weight, height, and age to see calorie estimates.';

  @override
  String get bmiGoalAggressiveCut => 'Aggressive Cut';

  @override
  String get bmiGoalCut => 'Cut';

  @override
  String get bmiGoalMaintenance => 'Maintenance';

  @override
  String get bmiGoalBulk => 'Bulk';

  @override
  String get bmiGoalAggressiveBulk => 'Aggressive Bulk';

  @override
  String get bmiSetAsGoalAction => 'Set as goal';

  @override
  String bmiGoalSetConfirmation(String preset) {
    return '$preset goals set.';
  }

  @override
  String get aiWorkoutSummaryLabel => 'Coach\'s Notes';

  @override
  String get aiWorkoutSummaryRevealAction => 'See what the coach thinks';

  @override
  String get aiWorkoutSummaryGenerating => 'Thinking it over…';
}
