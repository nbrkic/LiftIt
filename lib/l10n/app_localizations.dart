import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('sr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'LiftIt'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get navExercises;

  /// No description provided for @navStats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get navStats;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @drawerSplits.
  ///
  /// In en, this message translates to:
  /// **'Splits'**
  String get drawerSplits;

  /// No description provided for @drawerBodyweight.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight'**
  String get drawerBodyweight;

  /// No description provided for @drawerNutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get drawerNutrition;

  /// No description provided for @drawerStreaks.
  ///
  /// In en, this message translates to:
  /// **'Streaks'**
  String get drawerStreaks;

  /// No description provided for @drawerBmiCalculator.
  ///
  /// In en, this message translates to:
  /// **'BMI Calculator'**
  String get drawerBmiCalculator;

  /// No description provided for @drawerSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get drawerSettings;

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorMessage(String error);

  /// No description provided for @searchExercises.
  ///
  /// In en, this message translates to:
  /// **'Search exercises'**
  String get searchExercises;

  /// No description provided for @invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get invalid;

  /// No description provided for @enterAName.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get enterAName;

  /// No description provided for @freestyle.
  ///
  /// In en, this message translates to:
  /// **'Freestyle'**
  String get freestyle;

  /// No description provided for @exerciseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{muscleGroup} • {equipment}'**
  String exerciseSubtitle(String muscleGroup, String equipment);

  /// No description provided for @weightLabelWithUnit.
  ///
  /// In en, this message translates to:
  /// **'Weight ({unit})'**
  String weightLabelWithUnit(String unit);

  /// No description provided for @timesReps.
  ///
  /// In en, this message translates to:
  /// **'{weight} × {reps}'**
  String timesReps(String weight, int reps);

  /// No description provided for @rpeSuffix.
  ///
  /// In en, this message translates to:
  /// **' @ RPE {rpe}'**
  String rpeSuffix(String rpe);

  /// No description provided for @warmupSuffix.
  ///
  /// In en, this message translates to:
  /// **' (warm-up)'**
  String get warmupSuffix;

  /// No description provided for @repsRange.
  ///
  /// In en, this message translates to:
  /// **'{low}-{high} reps'**
  String repsRange(int low, int high);

  /// No description provided for @repsNotSet.
  ///
  /// In en, this message translates to:
  /// **'reps not set'**
  String get repsNotSet;

  /// No description provided for @lastTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Last time'**
  String get lastTimeLabel;

  /// No description provided for @newPrTag.
  ///
  /// In en, this message translates to:
  /// **'New PR'**
  String get newPrTag;

  /// No description provided for @restDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get restDismiss;

  /// No description provided for @setsLabel.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get setsLabel;

  /// No description provided for @workoutCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout Complete'**
  String get workoutCompleteTitle;

  /// No description provided for @doneButton.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneButton;

  /// No description provided for @deleteWorkoutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete workout?'**
  String get deleteWorkoutDialogTitle;

  /// No description provided for @deleteWorkoutDialogContent.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete this workout and all its logged sets. This cannot be undone.'**
  String get deleteWorkoutDialogContent;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @homeStartFreestyleWorkout.
  ///
  /// In en, this message translates to:
  /// **'Start Freestyle Workout'**
  String get homeStartFreestyleWorkout;

  /// No description provided for @homeResumeWorkout.
  ///
  /// In en, this message translates to:
  /// **'Resume Workout'**
  String get homeResumeWorkout;

  /// No description provided for @homeStartFromSplit.
  ///
  /// In en, this message translates to:
  /// **'Start From a Split'**
  String get homeStartFromSplit;

  /// No description provided for @workoutInProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'Workout in progress'**
  String get workoutInProgressLabel;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @homeCompletedMsg1.
  ///
  /// In en, this message translates to:
  /// **'Today\'s work is done. Recovery starts now.'**
  String get homeCompletedMsg1;

  /// No description provided for @homeCompletedMsg2.
  ///
  /// In en, this message translates to:
  /// **'Logged and locked in. That\'s today handled.'**
  String get homeCompletedMsg2;

  /// No description provided for @homeCompletedMsg3.
  ///
  /// In en, this message translates to:
  /// **'Another session banked. Consistency wins.'**
  String get homeCompletedMsg3;

  /// No description provided for @homeTodoMsg1.
  ///
  /// In en, this message translates to:
  /// **'No session logged yet today.'**
  String get homeTodoMsg1;

  /// No description provided for @homeTodoMsg2.
  ///
  /// In en, this message translates to:
  /// **'Today\'s still open — get a session in.'**
  String get homeTodoMsg2;

  /// No description provided for @homeTodoMsg3.
  ///
  /// In en, this message translates to:
  /// **'Nothing logged yet. The day\'s not over.'**
  String get homeTodoMsg3;

  /// No description provided for @homeRestMsg1.
  ///
  /// In en, this message translates to:
  /// **'Rest day. Recovery is part of the work.'**
  String get homeRestMsg1;

  /// No description provided for @homeRestMsg2.
  ///
  /// In en, this message translates to:
  /// **'Taking it easy today. That\'s the plan.'**
  String get homeRestMsg2;

  /// No description provided for @homeRestMsg3.
  ///
  /// In en, this message translates to:
  /// **'Rest day noted. Come back stronger.'**
  String get homeRestMsg3;

  /// No description provided for @homeMarkRestDayButton.
  ///
  /// In en, this message translates to:
  /// **'Today\'s a rest day'**
  String get homeMarkRestDayButton;

  /// No description provided for @homeNoStreakYet.
  ///
  /// In en, this message translates to:
  /// **'Train today to start a streak.'**
  String get homeNoStreakYet;

  /// No description provided for @streaksTitle.
  ///
  /// In en, this message translates to:
  /// **'Streaks'**
  String get streaksTitle;

  /// No description provided for @streakDaysCount.
  ///
  /// In en, this message translates to:
  /// **'{count} day streak'**
  String streakDaysCount(int count);

  /// No description provided for @streakDaysRequired.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String streakDaysRequired(int count);

  /// No description provided for @streakLevel1Name.
  ///
  /// In en, this message translates to:
  /// **'Spark'**
  String get streakLevel1Name;

  /// No description provided for @streakLevel2Name.
  ///
  /// In en, this message translates to:
  /// **'Ember'**
  String get streakLevel2Name;

  /// No description provided for @streakLevel3Name.
  ///
  /// In en, this message translates to:
  /// **'Flame'**
  String get streakLevel3Name;

  /// No description provided for @streakLevel4Name.
  ///
  /// In en, this message translates to:
  /// **'Blaze'**
  String get streakLevel4Name;

  /// No description provided for @streakLevel5Name.
  ///
  /// In en, this message translates to:
  /// **'Inferno'**
  String get streakLevel5Name;

  /// No description provided for @streakCurrentLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get streakCurrentLevelLabel;

  /// No description provided for @streakLockedLabel.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get streakLockedLabel;

  /// No description provided for @streakAchievedLabel.
  ///
  /// In en, this message translates to:
  /// **'Achieved'**
  String get streakAchievedLabel;

  /// No description provided for @streakScreenIntro.
  ///
  /// In en, this message translates to:
  /// **'Train (or mark a rest day) every day to build your streak. Miss a day and it resets.'**
  String get streakScreenIntro;

  /// No description provided for @nutritionTitle.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get nutritionTitle;

  /// No description provided for @nutritionTodayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get nutritionTodayLabel;

  /// No description provided for @nutritionCaloriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get nutritionCaloriesLabel;

  /// No description provided for @nutritionCaloriesUnitShort.
  ///
  /// In en, this message translates to:
  /// **'cal'**
  String get nutritionCaloriesUnitShort;

  /// No description provided for @nutritionProteinLabel.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get nutritionProteinLabel;

  /// No description provided for @nutritionCarbsLabel.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get nutritionCarbsLabel;

  /// No description provided for @nutritionFatLabel.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get nutritionFatLabel;

  /// No description provided for @nutritionWaterLabel.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get nutritionWaterLabel;

  /// No description provided for @nutritionUndoWaterAction.
  ///
  /// In en, this message translates to:
  /// **'Undo last'**
  String get nutritionUndoWaterAction;

  /// No description provided for @dailyWaterGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Water goal (L)'**
  String get dailyWaterGoalLabel;

  /// No description provided for @nutritionSupplementsLabel.
  ///
  /// In en, this message translates to:
  /// **'Supplements'**
  String get nutritionSupplementsLabel;

  /// No description provided for @nutritionManageSupplementsAction.
  ///
  /// In en, this message translates to:
  /// **'Manage supplements'**
  String get nutritionManageSupplementsAction;

  /// No description provided for @nutritionAddSupplementTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Supplement'**
  String get nutritionAddSupplementTitle;

  /// No description provided for @nutritionSupplementNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Supplement name'**
  String get nutritionSupplementNameLabel;

  /// No description provided for @nutritionSupplementDosageLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily amount (e.g. 5g)'**
  String get nutritionSupplementDosageLabel;

  /// No description provided for @nutritionSupplementsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No supplements added yet.'**
  String get nutritionSupplementsEmpty;

  /// No description provided for @deleteSupplementDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete supplement?'**
  String get deleteSupplementDialogTitle;

  /// No description provided for @deleteSupplementDialogContent.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete this supplement and its history.'**
  String get deleteSupplementDialogContent;

  /// No description provided for @nutritionEmptyDay.
  ///
  /// In en, this message translates to:
  /// **'No food logged yet — tap + to add.'**
  String get nutritionEmptyDay;

  /// No description provided for @nutritionLogFoodTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Food'**
  String get nutritionLogFoodTitle;

  /// No description provided for @nutritionFoodNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Food name'**
  String get nutritionFoodNameLabel;

  /// No description provided for @nutritionQuantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity (e.g. 150 g)'**
  String get nutritionQuantityLabel;

  /// No description provided for @nutritionEntryModeTotal.
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get nutritionEntryModeTotal;

  /// No description provided for @nutritionEntryModePer100g.
  ///
  /// In en, this message translates to:
  /// **'Per 100 g'**
  String get nutritionEntryModePer100g;

  /// No description provided for @nutritionPer100gCaloriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Calories /100g'**
  String get nutritionPer100gCaloriesLabel;

  /// No description provided for @nutritionPer100gProteinLabel.
  ///
  /// In en, this message translates to:
  /// **'Protein /100g'**
  String get nutritionPer100gProteinLabel;

  /// No description provided for @nutritionPer100gCarbsLabel.
  ///
  /// In en, this message translates to:
  /// **'Carbs /100g'**
  String get nutritionPer100gCarbsLabel;

  /// No description provided for @nutritionPer100gFatLabel.
  ///
  /// In en, this message translates to:
  /// **'Fat /100g'**
  String get nutritionPer100gFatLabel;

  /// No description provided for @nutritionCalculatedTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Calculated total'**
  String get nutritionCalculatedTotalLabel;

  /// No description provided for @nutritionSaveFoodOption.
  ///
  /// In en, this message translates to:
  /// **'Save food'**
  String get nutritionSaveFoodOption;

  /// No description provided for @nutritionLogButton.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get nutritionLogButton;

  /// No description provided for @nutritionSourceOpenFoodFacts.
  ///
  /// In en, this message translates to:
  /// **'Open Food Facts'**
  String get nutritionSourceOpenFoodFacts;

  /// No description provided for @nutritionSourceUsda.
  ///
  /// In en, this message translates to:
  /// **'USDA'**
  String get nutritionSourceUsda;

  /// No description provided for @nutritionSourceGemini.
  ///
  /// In en, this message translates to:
  /// **'Gemini'**
  String get nutritionSourceGemini;

  /// No description provided for @nutritionSourceManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get nutritionSourceManual;

  /// No description provided for @deleteFoodDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete entry?'**
  String get deleteFoodDialogTitle;

  /// No description provided for @deleteFoodDialogContent.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete this food log entry.'**
  String get deleteFoodDialogContent;

  /// No description provided for @deleteSavedFoodDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete saved food?'**
  String get deleteSavedFoodDialogTitle;

  /// No description provided for @deleteSavedFoodDialogContent.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete this saved food.'**
  String get deleteSavedFoodDialogContent;

  /// No description provided for @nutritionAddFoodTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Food'**
  String get nutritionAddFoodTitle;

  /// No description provided for @nutritionSearchOption.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get nutritionSearchOption;

  /// No description provided for @nutritionManualOption.
  ///
  /// In en, this message translates to:
  /// **'Enter Manually'**
  String get nutritionManualOption;

  /// No description provided for @nutritionLoadValuesOption.
  ///
  /// In en, this message translates to:
  /// **'Load Values'**
  String get nutritionLoadValuesOption;

  /// No description provided for @nutritionSavedFoodTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved Food'**
  String get nutritionSavedFoodTitle;

  /// No description provided for @nutritionSavedFoodEmpty.
  ///
  /// In en, this message translates to:
  /// **'No saved food yet.'**
  String get nutritionSavedFoodEmpty;

  /// No description provided for @nutritionPer100gBadge.
  ///
  /// In en, this message translates to:
  /// **'per 100 g'**
  String get nutritionPer100gBadge;

  /// No description provided for @nutritionSearchFoodHint.
  ///
  /// In en, this message translates to:
  /// **'Search food'**
  String get nutritionSearchFoodHint;

  /// No description provided for @nutritionSearchEmptyResults.
  ///
  /// In en, this message translates to:
  /// **'No results found.'**
  String get nutritionSearchEmptyResults;

  /// No description provided for @nutritionQuantityGramsLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity (g)'**
  String get nutritionQuantityGramsLabel;

  /// No description provided for @apiKeysSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'API Keys'**
  String get apiKeysSectionLabel;

  /// No description provided for @apiKeysDescription.
  ///
  /// In en, this message translates to:
  /// **'Optional and free. Your own keys stay on this device and are used only to search USDA\'s food database and analyze food photos with Gemini.'**
  String get apiKeysDescription;

  /// No description provided for @geminiApiKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'Gemini API key'**
  String get geminiApiKeyLabel;

  /// No description provided for @usdaApiKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'USDA API key'**
  String get usdaApiKeyLabel;

  /// No description provided for @nutritionUsdaKeyMissingHint.
  ///
  /// In en, this message translates to:
  /// **'Add a free USDA API key in Settings to also search generic foods, not just packaged products.'**
  String get nutritionUsdaKeyMissingHint;

  /// No description provided for @nutritionScanBarcodeOption.
  ///
  /// In en, this message translates to:
  /// **'Scan Barcode'**
  String get nutritionScanBarcodeOption;

  /// No description provided for @nutritionBarcodeNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product not found — you can still log it manually.'**
  String get nutritionBarcodeNotFound;

  /// No description provided for @nutritionCameraPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera access is needed to scan barcodes. Enable it in system Settings > Apps > Lift It > Permissions.'**
  String get nutritionCameraPermissionDenied;

  /// No description provided for @nutritionScannerUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Barcode scanning isn\'t supported on this device.'**
  String get nutritionScannerUnsupported;

  /// No description provided for @nutritionPhotoOption.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get nutritionPhotoOption;

  /// No description provided for @nutritionAiProcessing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing… this can take up to a minute.'**
  String get nutritionAiProcessing;

  /// No description provided for @nutritionGeminiKeyMissing.
  ///
  /// In en, this message translates to:
  /// **'Add a free Gemini API key in Settings to use photo recognition.'**
  String get nutritionGeminiKeyMissing;

  /// No description provided for @nutritionNoItemsRecognized.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t recognize any food in that photo. Try again or enter manually.'**
  String get nutritionNoItemsRecognized;

  /// No description provided for @nutritionPhotoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recognized Items'**
  String get nutritionPhotoResultsTitle;

  /// No description provided for @nutritionDescribeFoodTitle.
  ///
  /// In en, this message translates to:
  /// **'Describe the meal'**
  String get nutritionDescribeFoodTitle;

  /// No description provided for @nutritionDescribeFoodHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 2 eggs and toast'**
  String get nutritionDescribeFoodHint;

  /// No description provided for @nutritionEstimateButton.
  ///
  /// In en, this message translates to:
  /// **'Estimate'**
  String get nutritionEstimateButton;

  /// No description provided for @nutritionTryAiEstimateAction.
  ///
  /// In en, this message translates to:
  /// **'Try AI estimate'**
  String get nutritionTryAiEstimateAction;

  /// No description provided for @bodyweightTitle.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight'**
  String get bodyweightTitle;

  /// No description provided for @bodyweightLogWeighIn.
  ///
  /// In en, this message translates to:
  /// **'Log Weigh-in'**
  String get bodyweightLogWeighIn;

  /// No description provided for @bodyweightNoWeighInsYet.
  ///
  /// In en, this message translates to:
  /// **'No weigh-ins yet'**
  String get bodyweightNoWeighInsYet;

  /// No description provided for @bodyweightCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current: {weight}'**
  String bodyweightCurrent(String weight);

  /// No description provided for @historyLabel.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyLabel;

  /// No description provided for @bodyweightNoWeighInsYetTapToLog.
  ///
  /// In en, this message translates to:
  /// **'No weigh-ins yet — tap + to log one.'**
  String get bodyweightNoWeighInsYetTapToLog;

  /// No description provided for @bodyweightHistoryRow.
  ///
  /// In en, this message translates to:
  /// **'{date} • {notes}'**
  String bodyweightHistoryRow(String date, String notes);

  /// No description provided for @addExerciseTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Custom Exercise'**
  String get addExerciseTitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @muscleGroupLabel.
  ///
  /// In en, this message translates to:
  /// **'Muscle group'**
  String get muscleGroupLabel;

  /// No description provided for @equipmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get equipmentLabel;

  /// No description provided for @addExerciseButton.
  ///
  /// In en, this message translates to:
  /// **'Add Exercise'**
  String get addExerciseButton;

  /// No description provided for @exerciseFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get exerciseFallbackTitle;

  /// No description provided for @noSetsLoggedForExercise.
  ///
  /// In en, this message translates to:
  /// **'No sets logged for this exercise yet.'**
  String get noSetsLoggedForExercise;

  /// No description provided for @personalRecord.
  ///
  /// In en, this message translates to:
  /// **'Personal Record'**
  String get personalRecord;

  /// No description provided for @oneRepMaxTested.
  ///
  /// In en, this message translates to:
  /// **'1RM (tested)'**
  String get oneRepMaxTested;

  /// No description provided for @estimatedOneRepMax.
  ///
  /// In en, this message translates to:
  /// **'Estimated 1RM'**
  String get estimatedOneRepMax;

  /// No description provided for @progressChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Progressive Overload'**
  String get progressChartTitle;

  /// No description provided for @exercisesTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exercisesTitle;

  /// No description provided for @noExercisesFound.
  ///
  /// In en, this message translates to:
  /// **'No exercises found'**
  String get noExercisesFound;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @noWorkoutsYet.
  ///
  /// In en, this message translates to:
  /// **'No workouts yet'**
  String get noWorkoutsYet;

  /// No description provided for @historyRowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{date} • {minutes} min'**
  String historyRowSubtitle(String date, int minutes);

  /// No description provided for @noSetsLogged.
  ///
  /// In en, this message translates to:
  /// **'No sets logged'**
  String get noSetsLogged;

  /// No description provided for @minutesLabel.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutesLabel;

  /// No description provided for @volumeLabel.
  ///
  /// In en, this message translates to:
  /// **'volume'**
  String get volumeLabel;

  /// No description provided for @exerciseLabelSingular.
  ///
  /// In en, this message translates to:
  /// **'exercise'**
  String get exerciseLabelSingular;

  /// No description provided for @exerciseLabelPlural.
  ///
  /// In en, this message translates to:
  /// **'exercises'**
  String get exerciseLabelPlural;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// No description provided for @dateOfBirthLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirthLabel;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @genderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderLabel;

  /// No description provided for @heightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get heightLabel;

  /// No description provided for @experienceLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Experience level'**
  String get experienceLevelLabel;

  /// No description provided for @primaryGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Primary goal'**
  String get primaryGoalLabel;

  /// No description provided for @preferredWeightUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred weight unit'**
  String get preferredWeightUnitLabel;

  /// No description provided for @weeklyTrainingGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Weekly training goal (days)'**
  String get weeklyTrainingGoalLabel;

  /// No description provided for @nutritionGoalsSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Goals'**
  String get nutritionGoalsSectionLabel;

  /// No description provided for @dailyCalorieGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily calories'**
  String get dailyCalorieGoalLabel;

  /// No description provided for @dailyProteinGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily protein (g)'**
  String get dailyProteinGoalLabel;

  /// No description provided for @dailyCarbsGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily carbs (g)'**
  String get dailyCarbsGoalLabel;

  /// No description provided for @dailyFatGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily fat (g)'**
  String get dailyFatGoalLabel;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @logWeighInTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Weigh-in'**
  String get logWeighInTitle;

  /// No description provided for @notesOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptionalLabel;

  /// No description provided for @logWeightButton.
  ///
  /// In en, this message translates to:
  /// **'Log Weight'**
  String get logWeightButton;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @noNameSet.
  ///
  /// In en, this message translates to:
  /// **'No name set'**
  String get noNameSet;

  /// No description provided for @ageLabel.
  ///
  /// In en, this message translates to:
  /// **'Age: {age}'**
  String ageLabel(int age);

  /// No description provided for @genderValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender: {gender}'**
  String genderValueLabel(String gender);

  /// No description provided for @heightValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Height: {height} cm'**
  String heightValueLabel(String height);

  /// No description provided for @experienceValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Experience: {level}'**
  String experienceValueLabel(String level);

  /// No description provided for @goalValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal: {goal}'**
  String goalValueLabel(String goal);

  /// No description provided for @weeklyGoalValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Weekly goal: {days} days'**
  String weeklyGoalValueLabel(int days);

  /// No description provided for @preferredUnitValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred unit: {unit}'**
  String preferredUnitValueLabel(String unit);

  /// No description provided for @tapEditToFillProfile.
  ///
  /// In en, this message translates to:
  /// **'Tap the edit icon to fill in your profile.'**
  String get tapEditToFillProfile;

  /// No description provided for @basicInfoSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Basic Info'**
  String get basicInfoSectionLabel;

  /// No description provided for @editNutritionGoalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Nutrition Goals'**
  String get editNutritionGoalsTitle;

  /// No description provided for @noNutritionGoalsSet.
  ///
  /// In en, this message translates to:
  /// **'No nutrition goals set yet.'**
  String get noNutritionGoalsSet;

  /// No description provided for @dailyCalorieGoalValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Calorie goal: {value} cal'**
  String dailyCalorieGoalValueLabel(int value);

  /// No description provided for @dailyProteinGoalValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Protein goal: {value} g'**
  String dailyProteinGoalValueLabel(int value);

  /// No description provided for @dailyCarbsGoalValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Carbs goal: {value} g'**
  String dailyCarbsGoalValueLabel(int value);

  /// No description provided for @dailyFatGoalValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Fat goal: {value} g'**
  String dailyFatGoalValueLabel(int value);

  /// No description provided for @dailyWaterGoalValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Water goal: {value} L'**
  String dailyWaterGoalValueLabel(String value);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @appearanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceLabel;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSerbian.
  ///
  /// In en, this message translates to:
  /// **'Serbian'**
  String get languageSerbian;

  /// No description provided for @backupRestoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get backupRestoreLabel;

  /// No description provided for @backupDescription.
  ///
  /// In en, this message translates to:
  /// **'All your data lives only on this device. Export a backup regularly so you never lose your training history.'**
  String get backupDescription;

  /// No description provided for @exportBackupButton.
  ///
  /// In en, this message translates to:
  /// **'Export Backup'**
  String get exportBackupButton;

  /// No description provided for @restoreFromBackupButton.
  ///
  /// In en, this message translates to:
  /// **'Restore from Backup'**
  String get restoreFromBackupButton;

  /// No description provided for @aboutLabel.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutLabel;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionLabel(String version);

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'A free, no-nonsense gym tracker. All your data stays on this device.'**
  String get aboutDescription;

  /// No description provided for @backupShareText.
  ///
  /// In en, this message translates to:
  /// **'LiftIt backup'**
  String get backupShareText;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailed(String error);

  /// No description provided for @selectBackupFileTitle.
  ///
  /// In en, this message translates to:
  /// **'Select LiftIt backup file'**
  String get selectBackupFileTitle;

  /// No description provided for @restoreBackupDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore backup?'**
  String get restoreBackupDialogTitle;

  /// No description provided for @restoreBackupDialogContent.
  ///
  /// In en, this message translates to:
  /// **'This will replace all current data on this device with the backup. This cannot be undone.'**
  String get restoreBackupDialogContent;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @restoreButton.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restoreButton;

  /// No description provided for @restoreCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore complete'**
  String get restoreCompleteTitle;

  /// No description provided for @restoreCompleteContent.
  ///
  /// In en, this message translates to:
  /// **'LiftIt will now close. Reopen the app to see your restored data.'**
  String get restoreCompleteContent;

  /// No description provided for @closeAppButton.
  ///
  /// In en, this message translates to:
  /// **'Close App'**
  String get closeAppButton;

  /// No description provided for @addDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Day'**
  String get addDayTitle;

  /// No description provided for @dayNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Day name (e.g. Push Day)'**
  String get dayNameLabel;

  /// No description provided for @addDayButton.
  ///
  /// In en, this message translates to:
  /// **'Add Day'**
  String get addDayButton;

  /// No description provided for @createSplitTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Split'**
  String get createSplitTitle;

  /// No description provided for @splitNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name (e.g. Push Pull Legs)'**
  String get splitNameLabel;

  /// No description provided for @descriptionOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionOptionalLabel;

  /// No description provided for @createButton.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createButton;

  /// No description provided for @noExercisesYetTapToAdd.
  ///
  /// In en, this message translates to:
  /// **'No exercises yet — tap + to add one.'**
  String get noExercisesYetTapToAdd;

  /// No description provided for @setsRepsRangeSummary.
  ///
  /// In en, this message translates to:
  /// **'{sets} sets • {repsRange}'**
  String setsRepsRangeSummary(int sets, String repsRange);

  /// No description provided for @startWorkoutFromThisDay.
  ///
  /// In en, this message translates to:
  /// **'Start Workout From This Day'**
  String get startWorkoutFromThisDay;

  /// No description provided for @noDaysYetTapToAdd.
  ///
  /// In en, this message translates to:
  /// **'No days yet — tap + to add one.'**
  String get noDaysYetTapToAdd;

  /// No description provided for @splitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Splits'**
  String get splitsTitle;

  /// No description provided for @noSplitsYetTapToCreate.
  ///
  /// In en, this message translates to:
  /// **'No splits yet — tap + to create one.'**
  String get noSplitsYetTapToCreate;

  /// No description provided for @targetSetsLabel.
  ///
  /// In en, this message translates to:
  /// **'Target sets'**
  String get targetSetsLabel;

  /// No description provided for @repsFromOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Reps from (optional)'**
  String get repsFromOptionalLabel;

  /// No description provided for @repsToOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Reps to (optional)'**
  String get repsToOptionalLabel;

  /// No description provided for @addToDayButton.
  ///
  /// In en, this message translates to:
  /// **'Add to Day'**
  String get addToDayButton;

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get statsTitle;

  /// No description provided for @finishWorkoutToSeeStats.
  ///
  /// In en, this message translates to:
  /// **'Finish a workout to see stats here.'**
  String get finishWorkoutToSeeStats;

  /// No description provided for @totalWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Total Workouts'**
  String get totalWorkouts;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @avgPerWeek.
  ///
  /// In en, this message translates to:
  /// **'Avg / Week'**
  String get avgPerWeek;

  /// No description provided for @avgDuration.
  ///
  /// In en, this message translates to:
  /// **'Avg Duration'**
  String get avgDuration;

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String durationMinutes(int minutes);

  /// No description provided for @trainingVolumeWeekly.
  ///
  /// In en, this message translates to:
  /// **'Training Volume (weekly)'**
  String get trainingVolumeWeekly;

  /// No description provided for @noCompletedWorkoutsYet.
  ///
  /// In en, this message translates to:
  /// **'No completed workouts yet'**
  String get noCompletedWorkoutsYet;

  /// No description provided for @personalRecords.
  ///
  /// In en, this message translates to:
  /// **'Personal Records'**
  String get personalRecords;

  /// No description provided for @noSetsLoggedYet.
  ///
  /// In en, this message translates to:
  /// **'No sets logged yet.'**
  String get noSetsLoggedYet;

  /// No description provided for @volumeByMuscleGroup.
  ///
  /// In en, this message translates to:
  /// **'Volume by Muscle Group'**
  String get volumeByMuscleGroup;

  /// No description provided for @percentValue.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String percentValue(String value);

  /// No description provided for @activeWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Workout'**
  String get activeWorkoutTitle;

  /// No description provided for @finishButton.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finishButton;

  /// No description provided for @addExerciseFabLabel.
  ///
  /// In en, this message translates to:
  /// **'Add Exercise'**
  String get addExerciseFabLabel;

  /// No description provided for @noSetsLoggedTapAddExercise.
  ///
  /// In en, this message translates to:
  /// **'No sets logged yet — tap \"Add Exercise\" to start.'**
  String get noSetsLoggedTapAddExercise;

  /// No description provided for @restLabel.
  ///
  /// In en, this message translates to:
  /// **'Rest: {elapsed}'**
  String restLabel(String elapsed);

  /// No description provided for @setsProgress.
  ///
  /// In en, this message translates to:
  /// **'{logged}/{target} sets'**
  String setsProgress(int logged, int target);

  /// No description provided for @setsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sets'**
  String setsCount(int count);

  /// No description provided for @setRowLabel.
  ///
  /// In en, this message translates to:
  /// **'Set {number}  •  {weight} × {reps}'**
  String setRowLabel(int number, String weight, int reps);

  /// No description provided for @setNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Set {number}'**
  String setNumberLabel(int number);

  /// No description provided for @repsLabel.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get repsLabel;

  /// No description provided for @rpeOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'RPE (optional, 1-10)'**
  String get rpeOptionalLabel;

  /// No description provided for @rpeRangeError.
  ///
  /// In en, this message translates to:
  /// **'1-10'**
  String get rpeRangeError;

  /// No description provided for @noteOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteOptionalLabel;

  /// No description provided for @warmupSetLabel.
  ///
  /// In en, this message translates to:
  /// **'Warm-up set'**
  String get warmupSetLabel;

  /// No description provided for @logSetButton.
  ///
  /// In en, this message translates to:
  /// **'Log Set'**
  String get logSetButton;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get genderOther;

  /// No description provided for @genderPreferNotToSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get genderPreferNotToSay;

  /// No description provided for @experienceBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get experienceBeginner;

  /// No description provided for @experienceIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get experienceIntermediate;

  /// No description provided for @experienceAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get experienceAdvanced;

  /// No description provided for @goalStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get goalStrength;

  /// No description provided for @goalHypertrophy.
  ///
  /// In en, this message translates to:
  /// **'Hypertrophy'**
  String get goalHypertrophy;

  /// No description provided for @goalEndurance.
  ///
  /// In en, this message translates to:
  /// **'Endurance'**
  String get goalEndurance;

  /// No description provided for @goalWeightLoss.
  ///
  /// In en, this message translates to:
  /// **'Weight Loss'**
  String get goalWeightLoss;

  /// No description provided for @goalGeneralFitness.
  ///
  /// In en, this message translates to:
  /// **'General Fitness'**
  String get goalGeneralFitness;

  /// No description provided for @weightUnitKg.
  ///
  /// In en, this message translates to:
  /// **'Kilograms (kg)'**
  String get weightUnitKg;

  /// No description provided for @weightUnitLb.
  ///
  /// In en, this message translates to:
  /// **'Pounds (lb)'**
  String get weightUnitLb;

  /// No description provided for @muscleChest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get muscleChest;

  /// No description provided for @muscleBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get muscleBack;

  /// No description provided for @muscleShoulders.
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get muscleShoulders;

  /// No description provided for @muscleBiceps.
  ///
  /// In en, this message translates to:
  /// **'Biceps'**
  String get muscleBiceps;

  /// No description provided for @muscleTriceps.
  ///
  /// In en, this message translates to:
  /// **'Triceps'**
  String get muscleTriceps;

  /// No description provided for @muscleLegs.
  ///
  /// In en, this message translates to:
  /// **'Legs'**
  String get muscleLegs;

  /// No description provided for @muscleGlutes.
  ///
  /// In en, this message translates to:
  /// **'Glutes'**
  String get muscleGlutes;

  /// No description provided for @muscleCore.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get muscleCore;

  /// No description provided for @muscleCalves.
  ///
  /// In en, this message translates to:
  /// **'Calves'**
  String get muscleCalves;

  /// No description provided for @muscleForearms.
  ///
  /// In en, this message translates to:
  /// **'Forearms'**
  String get muscleForearms;

  /// No description provided for @muscleFullBody.
  ///
  /// In en, this message translates to:
  /// **'Full Body'**
  String get muscleFullBody;

  /// No description provided for @muscleCardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get muscleCardio;

  /// No description provided for @equipmentBarbell.
  ///
  /// In en, this message translates to:
  /// **'Barbell'**
  String get equipmentBarbell;

  /// No description provided for @equipmentDumbbell.
  ///
  /// In en, this message translates to:
  /// **'Dumbbell'**
  String get equipmentDumbbell;

  /// No description provided for @equipmentMachine.
  ///
  /// In en, this message translates to:
  /// **'Machine'**
  String get equipmentMachine;

  /// No description provided for @equipmentCable.
  ///
  /// In en, this message translates to:
  /// **'Cable'**
  String get equipmentCable;

  /// No description provided for @equipmentBodyweight.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight'**
  String get equipmentBodyweight;

  /// No description provided for @equipmentKettlebell.
  ///
  /// In en, this message translates to:
  /// **'Kettlebell'**
  String get equipmentKettlebell;

  /// No description provided for @equipmentBand.
  ///
  /// In en, this message translates to:
  /// **'Band'**
  String get equipmentBand;

  /// No description provided for @equipmentOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get equipmentOther;

  /// No description provided for @bmiCalculatorTitle.
  ///
  /// In en, this message translates to:
  /// **'BMI Calculator'**
  String get bmiCalculatorTitle;

  /// No description provided for @bmiWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get bmiWeightLabel;

  /// No description provided for @bmiAgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get bmiAgeLabel;

  /// No description provided for @bmiActivityLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Activity level'**
  String get bmiActivityLevelLabel;

  /// No description provided for @activityLevelSedentary.
  ///
  /// In en, this message translates to:
  /// **'Sedentary (little or no exercise)'**
  String get activityLevelSedentary;

  /// No description provided for @activityLevelLight.
  ///
  /// In en, this message translates to:
  /// **'Lightly active (1-3 days/week)'**
  String get activityLevelLight;

  /// No description provided for @activityLevelModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderately active (3-5 days/week)'**
  String get activityLevelModerate;

  /// No description provided for @activityLevelActive.
  ///
  /// In en, this message translates to:
  /// **'Very active (6-7 days/week)'**
  String get activityLevelActive;

  /// No description provided for @activityLevelVeryActive.
  ///
  /// In en, this message translates to:
  /// **'Extra active (hard exercise + physical job)'**
  String get activityLevelVeryActive;

  /// No description provided for @bmiResultLabel.
  ///
  /// In en, this message translates to:
  /// **'BMI: {value}'**
  String bmiResultLabel(String value);

  /// No description provided for @bmiCategoryUnderweight.
  ///
  /// In en, this message translates to:
  /// **'Underweight'**
  String get bmiCategoryUnderweight;

  /// No description provided for @bmiCategoryNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal weight'**
  String get bmiCategoryNormal;

  /// No description provided for @bmiCategoryOverweight.
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
  String get bmiCategoryOverweight;

  /// No description provided for @bmiCategoryObese.
  ///
  /// In en, this message translates to:
  /// **'Obese'**
  String get bmiCategoryObese;

  /// No description provided for @bmiMissingInputsHint.
  ///
  /// In en, this message translates to:
  /// **'Enter weight and height to see your BMI.'**
  String get bmiMissingInputsHint;

  /// No description provided for @bmiGoalsSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily Calorie & Macro Goals'**
  String get bmiGoalsSectionLabel;

  /// No description provided for @bmiGoalsMissingInputsHint.
  ///
  /// In en, this message translates to:
  /// **'Enter weight, height, and age to see calorie estimates.'**
  String get bmiGoalsMissingInputsHint;

  /// No description provided for @bmiGoalAggressiveCut.
  ///
  /// In en, this message translates to:
  /// **'Aggressive Cut'**
  String get bmiGoalAggressiveCut;

  /// No description provided for @bmiGoalCut.
  ///
  /// In en, this message translates to:
  /// **'Cut'**
  String get bmiGoalCut;

  /// No description provided for @bmiGoalMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get bmiGoalMaintenance;

  /// No description provided for @bmiGoalBulk.
  ///
  /// In en, this message translates to:
  /// **'Bulk'**
  String get bmiGoalBulk;

  /// No description provided for @bmiGoalAggressiveBulk.
  ///
  /// In en, this message translates to:
  /// **'Aggressive Bulk'**
  String get bmiGoalAggressiveBulk;

  /// No description provided for @bmiSetAsGoalAction.
  ///
  /// In en, this message translates to:
  /// **'Set as goal'**
  String get bmiSetAsGoalAction;

  /// No description provided for @bmiGoalSetConfirmation.
  ///
  /// In en, this message translates to:
  /// **'{preset} goals set.'**
  String bmiGoalSetConfirmation(String preset);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'sr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sr':
      return AppLocalizationsSr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
