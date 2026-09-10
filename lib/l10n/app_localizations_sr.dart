// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Serbian (`sr`).
class AppLocalizationsSr extends AppLocalizations {
  AppLocalizationsSr([String locale = 'sr']) : super(locale);

  @override
  String get appTitle => 'LiftIt';

  @override
  String get navHome => 'Početna';

  @override
  String get navHistory => 'Istorija';

  @override
  String get navExercises => 'Vežbe';

  @override
  String get navStats => 'Statistika';

  @override
  String get navProfile => 'Profil';

  @override
  String get drawerSplits => 'Splitovi';

  @override
  String get drawerBodyweight => 'Telesna težina';

  @override
  String get drawerNutrition => 'Ishrana';

  @override
  String get drawerStreaks => 'Nizovi';

  @override
  String get drawerBmiCalculator => 'BMI kalkulator';

  @override
  String get drawerSettings => 'Podešavanja';

  @override
  String errorMessage(String error) {
    return 'Greška: $error';
  }

  @override
  String get searchExercises => 'Pretraži vežbe';

  @override
  String get invalid => 'Nevažeće';

  @override
  String get enterAName => 'Unesi ime';

  @override
  String get freestyle => 'Freestyle';

  @override
  String exerciseSubtitle(String muscleGroup, String equipment) {
    return '$muscleGroup • $equipment';
  }

  @override
  String weightLabelWithUnit(String unit) {
    return 'Težina ($unit)';
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
  String get warmupSuffix => ' (zagrevanje)';

  @override
  String repsRange(int low, int high) {
    return '$low-$high ponavljanja';
  }

  @override
  String get repsNotSet => 'ponavljanja nisu podešena';

  @override
  String get lastTimeLabel => 'Prošli put';

  @override
  String get newPrTag => 'Novi rekord';

  @override
  String get restDismiss => 'Sakrij';

  @override
  String get setsLabel => 'Serije';

  @override
  String get workoutCompleteTitle => 'Trening završen';

  @override
  String get doneButton => 'Gotovo';

  @override
  String get deleteWorkoutDialogTitle => 'Obrisati trening?';

  @override
  String get deleteWorkoutDialogContent =>
      'Ovo će trajno obrisati ovaj trening i sve njegove ulogovane serije. Ova akcija se ne može poništiti.';

  @override
  String get deleteButton => 'Obriši';

  @override
  String get homeStartFreestyleWorkout => 'Započni slobodni trening';

  @override
  String get homeResumeWorkout => 'Nastavi trening';

  @override
  String get homeStartFromSplit => 'Započni iz splita';

  @override
  String get workoutInProgressLabel => 'Trening je u toku';

  @override
  String get greetingMorning => 'Dobro jutro';

  @override
  String get greetingAfternoon => 'Dobar dan';

  @override
  String get greetingEvening => 'Dobro veče';

  @override
  String get homeCompletedMsg1 =>
      'Današnji posao je završen. Oporavak počinje sada.';

  @override
  String get homeCompletedMsg2 => 'Ulogovano i gotovo. Danas je odrađeno.';

  @override
  String get homeCompletedMsg3 =>
      'Još jedan trening u banci. Doslednost pobeđuje.';

  @override
  String get homeTodoMsg1 => 'Danas još nije ulogovan trening.';

  @override
  String get homeTodoMsg2 => 'Dan je još otvoren — odradi trening.';

  @override
  String get homeTodoMsg3 => 'Još ništa nije ulogovano. Dan nije gotov.';

  @override
  String get homeRestMsg1 => 'Dan odmora. Oporavak je deo posla.';

  @override
  String get homeRestMsg2 => 'Danas se odmara. To je plan.';

  @override
  String get homeRestMsg3 => 'Dan odmora zabeležen. Vrati se jači.';

  @override
  String get homeMarkRestDayButton => 'Danas je dan odmora';

  @override
  String get homeNoStreakYet => 'Treniraj danas da započneš niz.';

  @override
  String get streaksTitle => 'Nizovi';

  @override
  String streakDaysCount(int count) {
    return 'Niz od $count dana';
  }

  @override
  String streakDaysRequired(int count) {
    return '$count dana';
  }

  @override
  String get streakLevel1Name => 'Iskra';

  @override
  String get streakLevel2Name => 'Žar';

  @override
  String get streakLevel3Name => 'Plamen';

  @override
  String get streakLevel4Name => 'Buktinja';

  @override
  String get streakLevel5Name => 'Inferno';

  @override
  String get streakCurrentLevelLabel => 'Trenutni';

  @override
  String get streakLockedLabel => 'Zaključano';

  @override
  String get streakAchievedLabel => 'Ostvareno';

  @override
  String get streakScreenIntro =>
      'Treniraj (ili obeleži dan odmora) svaki dan da bi gradio niz. Ako preskočiš dan, niz se resetuje.';

  @override
  String get nutritionTitle => 'Ishrana';

  @override
  String get nutritionTodayLabel => 'Danas';

  @override
  String get nutritionCaloriesLabel => 'Kalorije';

  @override
  String get nutritionCaloriesUnitShort => 'cal';

  @override
  String get nutritionProteinLabel => 'Proteini';

  @override
  String get nutritionCarbsLabel => 'Ugljeni hidrati';

  @override
  String get nutritionFatLabel => 'Masti';

  @override
  String get nutritionWaterLabel => 'Voda';

  @override
  String get nutritionUndoWaterAction => 'Poništi poslednje';

  @override
  String get dailyWaterGoalLabel => 'Cilj za vodu (L)';

  @override
  String get nutritionSupplementsLabel => 'Suplementi';

  @override
  String get nutritionManageSupplementsAction => 'Upravljaj suplementima';

  @override
  String get nutritionAddSupplementTitle => 'Dodaj suplement';

  @override
  String get nutritionSupplementNameLabel => 'Naziv suplementa';

  @override
  String get nutritionSupplementDosageLabel => 'Dnevna količina (npr. 5g)';

  @override
  String get nutritionSupplementsEmpty => 'Još nema dodatih suplemenata.';

  @override
  String get deleteSupplementDialogTitle => 'Obrisati suplement?';

  @override
  String get deleteSupplementDialogContent =>
      'Ovo će trajno obrisati ovaj suplement i njegovu istoriju.';

  @override
  String get nutritionEmptyDay =>
      'Još ništa nije ulogovano — dodirni + da dodaš.';

  @override
  String get nutritionLogFoodTitle => 'Uloguj hranu';

  @override
  String get nutritionFoodNameLabel => 'Naziv namirnice';

  @override
  String get nutritionQuantityLabel => 'Količina (npr. 150 g)';

  @override
  String get nutritionEntryModeTotal => 'Ukupna količina';

  @override
  String get nutritionEntryModePer100g => 'Na 100 g';

  @override
  String get nutritionPer100gCaloriesLabel => 'Kalorije /100g';

  @override
  String get nutritionPer100gProteinLabel => 'Proteini /100g';

  @override
  String get nutritionPer100gCarbsLabel => 'Ugljeni hidrati /100g';

  @override
  String get nutritionPer100gFatLabel => 'Masti /100g';

  @override
  String get nutritionCalculatedTotalLabel => 'Izračunato ukupno';

  @override
  String get nutritionSaveFoodOption => 'Sačuvaj hranu';

  @override
  String get nutritionLogButton => 'Uloguj';

  @override
  String get nutritionSourceOpenFoodFacts => 'Open Food Facts';

  @override
  String get nutritionSourceUsda => 'USDA';

  @override
  String get nutritionSourceGemini => 'Gemini';

  @override
  String get nutritionSourceManual => 'Ručno';

  @override
  String get deleteFoodDialogTitle => 'Obrisati unos?';

  @override
  String get deleteFoodDialogContent =>
      'Ovo će trajno obrisati ovaj unos hrane.';

  @override
  String get deleteSavedFoodDialogTitle => 'Obrisati sačuvanu hranu?';

  @override
  String get deleteSavedFoodDialogContent =>
      'Ovo će trajno obrisati ovu sačuvanu hranu.';

  @override
  String get nutritionAddFoodTitle => 'Dodaj hranu';

  @override
  String get nutritionSearchOption => 'Pretraga';

  @override
  String get nutritionManualOption => 'Ručni unos';

  @override
  String get nutritionLoadValuesOption => 'Učitaj vrednosti';

  @override
  String get nutritionSavedFoodTitle => 'Sačuvana hrana';

  @override
  String get nutritionSavedFoodEmpty => 'Još nema sačuvane hrane.';

  @override
  String get nutritionPer100gBadge => 'na 100 g';

  @override
  String get nutritionSearchFoodHint => 'Pretraži hranu';

  @override
  String get nutritionSearchEmptyResults => 'Nema rezultata.';

  @override
  String get nutritionQuantityGramsLabel => 'Količina (g)';

  @override
  String get apiKeysSectionLabel => 'API ključevi';

  @override
  String get apiKeysDescription =>
      'Opciono i besplatno. Tvoji sopstveni ključevi ostaju samo na ovom uređaju i koriste se samo za pretragu USDA baze hrane i analizu slika hrane preko Gemini-ja.';

  @override
  String get geminiApiKeyLabel => 'Gemini API ključ';

  @override
  String get usdaApiKeyLabel => 'USDA API ključ';

  @override
  String get nutritionUsdaKeyMissingHint =>
      'Dodaj besplatan USDA API ključ u Podešavanjima da bi pretraživao i generičku hranu, ne samo pakovane proizvode.';

  @override
  String get nutritionScanBarcodeOption => 'Skeniraj bar kod';

  @override
  String get nutritionBarcodeNotFound =>
      'Proizvod nije pronađen — i dalje možeš da ga uneseš ručno.';

  @override
  String get nutritionCameraPermissionDenied =>
      'Potreban je pristup kameri za skeniranje bar koda. Omogući ga u Podešavanja > Aplikacije > Lift It > Dozvole.';

  @override
  String get nutritionScannerUnsupported =>
      'Skeniranje bar koda nije podržano na ovom uređaju.';

  @override
  String get nutritionPhotoOption => 'Slika';

  @override
  String get nutritionAiProcessing =>
      'Analiziram… ovo može potrajati i do minut.';

  @override
  String get nutritionGeminiKeyMissing =>
      'Dodaj besplatan Gemini API ključ u Podešavanjima da bi koristio prepoznavanje sa slike.';

  @override
  String get nutritionNoItemsRecognized =>
      'Nisam uspeo da prepoznam hranu na toj slici. Probaj ponovo ili unesi ručno.';

  @override
  String get nutritionPhotoResultsTitle => 'Prepoznate stavke';

  @override
  String get nutritionDescribeFoodTitle => 'Opiši obrok';

  @override
  String get nutritionDescribeFoodHint => 'npr. 2 jajeta i tost';

  @override
  String get nutritionEstimateButton => 'Proceni';

  @override
  String get nutritionTryAiEstimateAction => 'Probaj AI procenu';

  @override
  String get bodyweightTitle => 'Telesna težina';

  @override
  String get bodyweightLogWeighIn => 'Unesi merenje';

  @override
  String get bodyweightNoWeighInsYet => 'Još nema merenja';

  @override
  String bodyweightCurrent(String weight) {
    return 'Trenutno: $weight';
  }

  @override
  String get historyLabel => 'Istorija';

  @override
  String get bodyweightNoWeighInsYetTapToLog =>
      'Još nema merenja — dodirni + da uneseš prvo.';

  @override
  String bodyweightHistoryRow(String date, String notes) {
    return '$date • $notes';
  }

  @override
  String get addExerciseTitle => 'Dodaj sopstvenu vežbu';

  @override
  String get nameLabel => 'Ime';

  @override
  String get muscleGroupLabel => 'Mišićna grupa';

  @override
  String get equipmentLabel => 'Oprema';

  @override
  String get addExerciseButton => 'Dodaj vežbu';

  @override
  String get exerciseFallbackTitle => 'Vežba';

  @override
  String get noSetsLoggedForExercise =>
      'Za ovu vežbu još nema ulogovanih serija.';

  @override
  String get personalRecord => 'Lični rekord';

  @override
  String get oneRepMaxTested => '1RM (testirano)';

  @override
  String get estimatedOneRepMax => 'Procenjeni 1RM';

  @override
  String get progressChartTitle => 'Progresivno opterećenje';

  @override
  String get exercisesTitle => 'Vežbe';

  @override
  String get noExercisesFound => 'Nema pronađenih vežbi';

  @override
  String get historyTitle => 'Istorija';

  @override
  String get noWorkoutsYet => 'Još nema treninga';

  @override
  String historyRowSubtitle(String date, int minutes) {
    return '$date • $minutes min';
  }

  @override
  String get noSetsLogged => 'Nema ulogovanih serija';

  @override
  String get minutesLabel => 'minuta';

  @override
  String get volumeLabel => 'volumen';

  @override
  String get exerciseLabelSingular => 'vežba';

  @override
  String get exerciseLabelPlural => 'vežbi';

  @override
  String get editProfileTitle => 'Izmeni profil';

  @override
  String get dateOfBirthLabel => 'Datum rođenja';

  @override
  String get notSet => 'Nije podešeno';

  @override
  String get genderLabel => 'Pol';

  @override
  String get heightLabel => 'Visina (cm)';

  @override
  String get experienceLevelLabel => 'Nivo iskustva';

  @override
  String get primaryGoalLabel => 'Primarni cilj';

  @override
  String get preferredWeightUnitLabel => 'Preferirana jedinica za težinu';

  @override
  String get weeklyTrainingGoalLabel => 'Nedeljni cilj treninga (dana)';

  @override
  String get nutritionGoalsSectionLabel => 'Ciljevi ishrane';

  @override
  String get dailyCalorieGoalLabel => 'Dnevne kalorije';

  @override
  String get dailyProteinGoalLabel => 'Dnevni proteini (g)';

  @override
  String get dailyCarbsGoalLabel => 'Dnevni ugljeni hidrati (g)';

  @override
  String get dailyFatGoalLabel => 'Dnevne masti (g)';

  @override
  String get saveButton => 'Sačuvaj';

  @override
  String get logWeighInTitle => 'Unesi merenje';

  @override
  String get notesOptionalLabel => 'Napomena (opciono)';

  @override
  String get logWeightButton => 'Unesi težinu';

  @override
  String get profileTitle => 'Profil';

  @override
  String get noNameSet => 'Ime nije uneto';

  @override
  String ageLabel(int age) {
    return 'Godine: $age';
  }

  @override
  String genderValueLabel(String gender) {
    return 'Pol: $gender';
  }

  @override
  String heightValueLabel(String height) {
    return 'Visina: $height cm';
  }

  @override
  String experienceValueLabel(String level) {
    return 'Iskustvo: $level';
  }

  @override
  String goalValueLabel(String goal) {
    return 'Cilj: $goal';
  }

  @override
  String weeklyGoalValueLabel(int days) {
    return 'Nedeljni cilj: $days dana';
  }

  @override
  String preferredUnitValueLabel(String unit) {
    return 'Preferirana jedinica: $unit';
  }

  @override
  String get tapEditToFillProfile =>
      'Dodirni ikonicu za izmenu da popuniš profil.';

  @override
  String get basicInfoSectionLabel => 'Osnovni podaci';

  @override
  String get editNutritionGoalsTitle => 'Izmeni nutritivne ciljeve';

  @override
  String get noNutritionGoalsSet => 'Nutritivni ciljevi još nisu podešeni.';

  @override
  String dailyCalorieGoalValueLabel(int value) {
    return 'Cilj kalorija: $value cal';
  }

  @override
  String dailyProteinGoalValueLabel(int value) {
    return 'Cilj proteina: $value g';
  }

  @override
  String dailyCarbsGoalValueLabel(int value) {
    return 'Cilj ugljenih hidrata: $value g';
  }

  @override
  String dailyFatGoalValueLabel(int value) {
    return 'Cilj masti: $value g';
  }

  @override
  String dailyWaterGoalValueLabel(String value) {
    return 'Cilj za vodu: $value L';
  }

  @override
  String get settingsTitle => 'Podešavanja';

  @override
  String get appearanceLabel => 'Izgled';

  @override
  String get themeSystem => 'Sistemski';

  @override
  String get themeLight => 'Svetla';

  @override
  String get themeDark => 'Tamna';

  @override
  String get languageLabel => 'Jezik';

  @override
  String get languageEnglish => 'Engleski';

  @override
  String get languageSerbian => 'Srpski';

  @override
  String get backupRestoreLabel => 'Rezervna kopija i vraćanje';

  @override
  String get backupDescription =>
      'Svi tvoji podaci se čuvaju samo na ovom uređaju. Redovno pravi rezervnu kopiju da ne bi izgubio istoriju treninga.';

  @override
  String get exportBackupButton => 'Izvezi rezervnu kopiju';

  @override
  String get restoreFromBackupButton => 'Vrati iz rezervne kopije';

  @override
  String get aboutLabel => 'O aplikaciji';

  @override
  String versionLabel(String version) {
    return 'Verzija $version';
  }

  @override
  String get aboutDescription =>
      'Besplatan, jednostavan gym tracker. Svi tvoji podaci ostaju na ovom uređaju.';

  @override
  String get backupShareText => 'LiftIt rezervna kopija';

  @override
  String exportFailed(String error) {
    return 'Izvoz nije uspeo: $error';
  }

  @override
  String get selectBackupFileTitle => 'Izaberi LiftIt fajl rezervne kopije';

  @override
  String get restoreBackupDialogTitle => 'Vratiti rezervnu kopiju?';

  @override
  String get restoreBackupDialogContent =>
      'Ovo će zameniti sve trenutne podatke na uređaju sa rezervnom kopijom. Ova akcija se ne može poništiti.';

  @override
  String get cancelButton => 'Otkaži';

  @override
  String get restoreButton => 'Vrati';

  @override
  String get restoreCompleteTitle => 'Vraćanje završeno';

  @override
  String get restoreCompleteContent =>
      'LiftIt će se sada zatvoriti. Ponovo otvori aplikaciju da vidiš vraćene podatke.';

  @override
  String get closeAppButton => 'Zatvori aplikaciju';

  @override
  String get addDayTitle => 'Dodaj dan';

  @override
  String get dayNameLabel => 'Ime dana (npr. Push Day)';

  @override
  String get addDayButton => 'Dodaj dan';

  @override
  String get createSplitTitle => 'Napravi split';

  @override
  String get splitNameLabel => 'Ime (npr. Push Pull Legs)';

  @override
  String get descriptionOptionalLabel => 'Opis (opciono)';

  @override
  String get createButton => 'Napravi';

  @override
  String get noExercisesYetTapToAdd =>
      'Još nema vežbi — dodirni + da dodaš jednu.';

  @override
  String setsRepsRangeSummary(int sets, String repsRange) {
    return '$sets serija • $repsRange';
  }

  @override
  String get startWorkoutFromThisDay => 'Započni trening iz ovog dana';

  @override
  String get noDaysYetTapToAdd => 'Još nema dana — dodirni + da dodaš jedan.';

  @override
  String get splitsTitle => 'Splitovi';

  @override
  String get noSplitsYetTapToCreate =>
      'Još nema splitova — dodirni + da napraviš jedan.';

  @override
  String get targetSetsLabel => 'Ciljani broj serija';

  @override
  String get repsFromOptionalLabel => 'Ponavljanja od (opciono)';

  @override
  String get repsToOptionalLabel => 'Ponavljanja do (opciono)';

  @override
  String get addToDayButton => 'Dodaj u dan';

  @override
  String get statsTitle => 'Statistika';

  @override
  String get finishWorkoutToSeeStats =>
      'Završi trening da vidiš statistiku ovde.';

  @override
  String get totalWorkouts => 'Ukupno treninga';

  @override
  String get currentStreak => 'Trenutni niz';

  @override
  String get avgPerWeek => 'Prosek / nedeljno';

  @override
  String get avgDuration => 'Prosečno trajanje';

  @override
  String durationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get trainingVolumeWeekly => 'Nedeljni volumen treninga';

  @override
  String get noCompletedWorkoutsYet => 'Još nema završenih treninga';

  @override
  String get personalRecords => 'Lični rekordi';

  @override
  String get noSetsLoggedYet => 'Još nema ulogovanih serija.';

  @override
  String get volumeByMuscleGroup => 'Volumen po mišićnim grupama';

  @override
  String percentValue(String value) {
    return '$value%';
  }

  @override
  String get activeWorkoutTitle => 'Aktivan trening';

  @override
  String get finishButton => 'Završi';

  @override
  String get addExerciseFabLabel => 'Dodaj vežbu';

  @override
  String get noSetsLoggedTapAddExercise =>
      'Još nema ulogovanih serija — dodirni „Dodaj vežbu” da počneš.';

  @override
  String restLabel(String elapsed) {
    return 'Odmor: $elapsed';
  }

  @override
  String setsProgress(int logged, int target) {
    return '$logged/$target serija';
  }

  @override
  String setsCount(int count) {
    return '$count serija';
  }

  @override
  String setRowLabel(int number, String weight, int reps) {
    return 'Serija $number  •  $weight × $reps';
  }

  @override
  String setNumberLabel(int number) {
    return 'Serija $number';
  }

  @override
  String get repsLabel => 'Ponavljanja';

  @override
  String get rpeOptionalLabel => 'RPE (opciono, 1-10)';

  @override
  String get rpeRangeError => '1-10';

  @override
  String get noteOptionalLabel => 'Napomena (opciono)';

  @override
  String get warmupSetLabel => 'Zagrevanje';

  @override
  String get logSetButton => 'Uloguj seriju';

  @override
  String get genderMale => 'Muško';

  @override
  String get genderFemale => 'Žensko';

  @override
  String get genderOther => 'Drugo';

  @override
  String get genderPreferNotToSay => 'Ne želim da kažem';

  @override
  String get experienceBeginner => 'Početnik';

  @override
  String get experienceIntermediate => 'Srednji nivo';

  @override
  String get experienceAdvanced => 'Napredan';

  @override
  String get goalStrength => 'Snaga';

  @override
  String get goalHypertrophy => 'Hipertrofija';

  @override
  String get goalEndurance => 'Izdržljivost';

  @override
  String get goalWeightLoss => 'Mršavljenje';

  @override
  String get goalGeneralFitness => 'Opšta forma';

  @override
  String get weightUnitKg => 'Kilogrami (kg)';

  @override
  String get weightUnitLb => 'Funte (lb)';

  @override
  String get muscleChest => 'Grudi';

  @override
  String get muscleBack => 'Leđa';

  @override
  String get muscleShoulders => 'Ramena';

  @override
  String get muscleBiceps => 'Biceps';

  @override
  String get muscleTriceps => 'Triceps';

  @override
  String get muscleLegs => 'Noge';

  @override
  String get muscleGlutes => 'Gluteusi';

  @override
  String get muscleCore => 'Stomak';

  @override
  String get muscleCalves => 'Listovi';

  @override
  String get muscleForearms => 'Podlaktice';

  @override
  String get muscleFullBody => 'Celo telo';

  @override
  String get muscleCardio => 'Kardio';

  @override
  String get equipmentBarbell => 'Šipka';

  @override
  String get equipmentDumbbell => 'Bučica';

  @override
  String get equipmentMachine => 'Sprava';

  @override
  String get equipmentCable => 'Sajla';

  @override
  String get equipmentBodyweight => 'Sopstvena težina';

  @override
  String get equipmentKettlebell => 'Kettlebell';

  @override
  String get equipmentBand => 'Traka';

  @override
  String get equipmentOther => 'Ostalo';

  @override
  String get bmiCalculatorTitle => 'BMI kalkulator';

  @override
  String get bmiWeightLabel => 'Težina (kg)';

  @override
  String get bmiAgeLabel => 'Godine';

  @override
  String get bmiActivityLevelLabel => 'Nivo aktivnosti';

  @override
  String get activityLevelSedentary => 'Sedentaran (malo ili nimalo vežbanja)';

  @override
  String get activityLevelLight => 'Lako aktivan (1-3 dana nedeljno)';

  @override
  String get activityLevelModerate => 'Umereno aktivan (3-5 dana nedeljno)';

  @override
  String get activityLevelActive => 'Vrlo aktivan (6-7 dana nedeljno)';

  @override
  String get activityLevelVeryActive =>
      'Ekstra aktivan (teško vežbanje + fizički posao)';

  @override
  String bmiResultLabel(String value) {
    return 'BMI: $value';
  }

  @override
  String get bmiCategoryUnderweight => 'Pothranjenost';

  @override
  String get bmiCategoryNormal => 'Normalna težina';

  @override
  String get bmiCategoryOverweight => 'Prekomerna težina';

  @override
  String get bmiCategoryObese => 'Gojaznost';

  @override
  String get bmiMissingInputsHint => 'Unesi težinu i visinu da vidiš svoj BMI.';

  @override
  String get bmiGoalsSectionLabel =>
      'Dnevni ciljevi kalorija i makronutrijenata';

  @override
  String get bmiGoalsMissingInputsHint =>
      'Unesi težinu, visinu i godine da vidiš procenu kalorija.';

  @override
  String get bmiGoalAggressiveCut => 'Agresivan cut';

  @override
  String get bmiGoalCut => 'Cut';

  @override
  String get bmiGoalMaintenance => 'Održavanje';

  @override
  String get bmiGoalBulk => 'Bulk';

  @override
  String get bmiGoalAggressiveBulk => 'Agresivan bulk';

  @override
  String get bmiSetAsGoalAction => 'Postavi kao cilj';

  @override
  String bmiGoalSetConfirmation(String preset) {
    return 'Ciljevi za \"$preset\" su podešeni.';
  }
}
