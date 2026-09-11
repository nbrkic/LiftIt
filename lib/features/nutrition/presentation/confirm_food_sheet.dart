import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/date_utils.dart';
import '../../../database/enums.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/lift_button.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/food_log_providers.dart';
import '../providers/saved_foods_providers.dart';
import '../services/food_search_result.dart';

// Shared by every add-food path (manual, barcode, search, photo).
// Three modes:
//  - `searchResult` set: OFF/USDA per-100g match — quantity is editable
//    grams, macros recompute live as it changes.
//  - `searchResult` null, manual entry, per-100g toggle on: the user types
//    the per-100g values themselves (there's no external source to supply
//    them), then a grams-eaten quantity — macros recompute live exactly
//    like the search path, just fed from typed values instead of an API.
//  - `searchResult` null otherwise (plain manual entry, or an absolute
//    Gemini estimate): quantity is a free-text label, macros are
//    independently typed.
// Every field stays directly editable either way, so a bad API value or a
// bad live-computed guess is never a dead end.
class ConfirmFoodSheet extends ConsumerStatefulWidget {
  final FoodSearchResult? searchResult;
  final String? initialName;
  final String? initialQuantityLabel;
  final double? initialCalories;
  final double? initialProteinG;
  final double? initialCarbsG;
  final double? initialFatG;
  final FoodLogSource source;
  final String? sourceId;
  // The diary day this entry is being logged into — not necessarily today,
  // since the diary lets you browse to a past day and log/fix entries
  // there. Combined with the current wall-clock time at submit so entries
  // still order sensibly within that day.
  final DateTime day;

  const ConfirmFoodSheet({
    super.key,
    this.searchResult,
    this.initialName,
    this.initialQuantityLabel,
    this.initialCalories,
    this.initialProteinG,
    this.initialCarbsG,
    this.initialFatG,
    this.source = FoodLogSource.manual,
    this.sourceId,
    required this.day,
  });

  @override
  ConsumerState<ConfirmFoodSheet> createState() => _ConfirmFoodSheetState();
}

class _ConfirmFoodSheetState extends ConsumerState<ConfirmFoodSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  late final TextEditingController _caloriesController;
  late final TextEditingController _proteinController;
  late final TextEditingController _carbsController;
  late final TextEditingController _fatController;
  late final TextEditingController _per100gCaloriesController;
  late final TextEditingController _per100gProteinController;
  late final TextEditingController _per100gCarbsController;
  late final TextEditingController _per100gFatController;

  bool _manualPer100gMode = false;
  bool _saveToMyFoods = false;

  // Only a plain manual entry can offer the per-100g toggle — a search/
  // barcode result already IS a per-100g match, and a Gemini estimate is
  // already an absolute plate-of-food guess with no "per 100g" to speak of.
  bool get _showManualModeToggle =>
      widget.searchResult == null && widget.source == FoodLogSource.manual;

  bool get _hasGramsQuantity => widget.searchResult != null || _manualPer100gMode;

  @override
  void initState() {
    super.initState();
    final sr = widget.searchResult;
    _per100gCaloriesController = TextEditingController();
    _per100gProteinController = TextEditingController();
    _per100gCarbsController = TextEditingController();
    _per100gFatController = TextEditingController();
    if (sr != null) {
      _nameController = TextEditingController(text: sr.name);
      _quantityController = TextEditingController(text: '100');
      final scaled = scaleToQuantity(sr, 100);
      _caloriesController = TextEditingController(text: scaled.calories.round().toString());
      _proteinController = TextEditingController(text: scaled.proteinG.round().toString());
      _carbsController = TextEditingController(text: scaled.carbsG.round().toString());
      _fatController = TextEditingController(text: scaled.fatG.round().toString());
      _quantityController.addListener(_recalculateFromQuantity);
    } else {
      _nameController = TextEditingController(text: widget.initialName ?? '');
      _quantityController = TextEditingController(text: widget.initialQuantityLabel ?? '');
      _caloriesController =
          TextEditingController(text: widget.initialCalories?.round().toString() ?? '');
      _proteinController =
          TextEditingController(text: widget.initialProteinG?.round().toString() ?? '');
      _carbsController =
          TextEditingController(text: widget.initialCarbsG?.round().toString() ?? '');
      _fatController = TextEditingController(text: widget.initialFatG?.round().toString() ?? '');
      _quantityController.addListener(_recalculateManualPer100g);
      _per100gCaloriesController.addListener(_recalculateManualPer100g);
      _per100gProteinController.addListener(_recalculateManualPer100g);
      _per100gCarbsController.addListener(_recalculateManualPer100g);
      _per100gFatController.addListener(_recalculateManualPer100g);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _per100gCaloriesController.dispose();
    _per100gProteinController.dispose();
    _per100gCarbsController.dispose();
    _per100gFatController.dispose();
    super.dispose();
  }

  void _onModeChanged(bool per100g) {
    setState(() {
      _manualPer100gMode = per100g;
      // The quantity field's meaning flips between a numeric grams-eaten
      // value and a free-text label — a leftover value from the other mode
      // would be either unparseable or a meaningless "100".
      _quantityController.text = per100g ? '100' : '';
      if (per100g) _recalculateManualPer100g();
    });
  }

  void _recalculateFromQuantity() {
    final grams = double.tryParse(_quantityController.text.replaceAll(',', '.'));
    if (grams == null) return;
    final scaled = scaleToQuantity(widget.searchResult!, grams);
    _caloriesController.text = scaled.calories.round().toString();
    _proteinController.text = scaled.proteinG.round().toString();
    _carbsController.text = scaled.carbsG.round().toString();
    _fatController.text = scaled.fatG.round().toString();
  }

  void _recalculateManualPer100g() {
    if (!_manualPer100gMode) return;
    final grams = double.tryParse(_quantityController.text.replaceAll(',', '.'));
    if (grams == null) return;
    final per100g = FoodSearchResult(
      name: '',
      caloriesPer100g: _num(_per100gCaloriesController),
      proteinPer100g: _num(_per100gProteinController),
      carbsPer100g: _num(_per100gCarbsController),
      fatPer100g: _num(_per100gFatController),
      source: FoodLogSource.manual,
    );
    final scaled = scaleToQuantity(per100g, grams);
    _caloriesController.text = scaled.calories.round().toString();
    _proteinController.text = scaled.proteinG.round().toString();
    _carbsController.text = scaled.carbsG.round().toString();
    _fatController.text = scaled.fatG.round().toString();
  }

  double _num(TextEditingController c) => double.tryParse(c.text.replaceAll(',', '.')) ?? 0;

  // Saved separately from the logged (possibly quantity-scaled) values —
  // a saved food should be reusable at any quantity next time, so a
  // per-100g source (a search/barcode match, or manual per-100g entry)
  // saves its per-100g figures, not today's scaled amount.
  Future<void> _maybeSaveToMyFoods() async {
    if (!_saveToMyFoods) return;
    final sr = widget.searchResult;
    final isPer100g = sr != null || _manualPer100gMode;
    final double calories, proteinG, carbsG, fatG;
    final String quantityLabel;
    if (sr != null) {
      calories = sr.caloriesPer100g;
      proteinG = sr.proteinPer100g;
      carbsG = sr.carbsPer100g;
      fatG = sr.fatPer100g;
      quantityLabel = '100 g';
    } else if (_manualPer100gMode) {
      calories = _num(_per100gCaloriesController);
      proteinG = _num(_per100gProteinController);
      carbsG = _num(_per100gCarbsController);
      fatG = _num(_per100gFatController);
      quantityLabel = '100 g';
    } else {
      calories = _num(_caloriesController);
      proteinG = _num(_proteinController);
      carbsG = _num(_carbsController);
      fatG = _num(_fatController);
      quantityLabel = _quantityController.text.trim();
    }
    await ref.read(savedFoodsControllerProvider).saveFood(
          name: _nameController.text.trim(),
          brand: sr?.brand,
          quantityLabel: quantityLabel,
          calories: calories,
          proteinG: proteinG,
          carbsG: carbsG,
          fatG: fatG,
          isPer100g: isPer100g,
        );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final quantityLabel = _hasGramsQuantity
        ? '${_num(_quantityController).round()} g'
        : _quantityController.text.trim();
    await ref.read(foodLogControllerProvider).logEntry(
          name: _nameController.text.trim(),
          brand: widget.searchResult?.brand,
          quantityLabel: quantityLabel,
          calories: _num(_caloriesController),
          proteinG: _num(_proteinController),
          carbsG: _num(_carbsController),
          fatG: _num(_fatController),
          source: widget.searchResult?.source ?? widget.source,
          sourceId: widget.searchResult?.sourceId ?? widget.sourceId,
          loggedAt: combineDayWithCurrentTime(widget.day),
        );
    await _maybeSaveToMyFoods();
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.xxl,
        right: AppSpacing.xxl,
        top: AppSpacing.xl,
        bottom: MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).padding.bottom +
            AppSpacing.xxl,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.nutritionLogFoodTitle, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.xl),
              if (_showManualModeToggle) ...[
                SegmentedButton<bool>(
                  segments: [
                    ButtonSegment(value: false, label: Text(l10n.nutritionEntryModeTotal)),
                    ButtonSegment(value: true, label: Text(l10n.nutritionEntryModePer100g)),
                  ],
                  selected: {_manualPer100gMode},
                  onSelectionChanged: (selection) => _onModeChanged(selection.first),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              TextFormField(
                controller: _nameController,
                autofocus: widget.initialName == null && !_hasGramsQuantity,
                decoration: InputDecoration(labelText: l10n.nutritionFoodNameLabel),
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? l10n.enterAName : null,
              ),
              const SizedBox(height: AppSpacing.md),
              if (_manualPer100gMode) ...[
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _per100gCaloriesController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration:
                            InputDecoration(labelText: l10n.nutritionPer100gCaloriesLabel),
                        validator: (value) => double.tryParse((value ?? '').replaceAll(',', '.')) ==
                                null
                            ? l10n.invalid
                            : null,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextFormField(
                        controller: _per100gProteinController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(labelText: l10n.nutritionPer100gProteinLabel),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _per100gCarbsController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(labelText: l10n.nutritionPer100gCarbsLabel),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextFormField(
                        controller: _per100gFatController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(labelText: l10n.nutritionPer100gFatLabel),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              TextFormField(
                controller: _quantityController,
                keyboardType: _hasGramsQuantity
                    ? const TextInputType.numberWithOptions(decimal: true)
                    : TextInputType.text,
                decoration: InputDecoration(
                  labelText:
                      _hasGramsQuantity ? l10n.nutritionQuantityGramsLabel : l10n.nutritionQuantityLabel,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return l10n.enterAName;
                  if (_hasGramsQuantity && double.tryParse(value.replaceAll(',', '.')) == null) {
                    return l10n.invalid;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              if (_manualPer100gMode) ...[
                Text(
                  l10n.nutritionCalculatedTotalLabel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.textSecondary),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              TextFormField(
                controller: _caloriesController,
                readOnly: _manualPer100gMode,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: l10n.nutritionCaloriesLabel),
                validator: (value) =>
                    double.tryParse((value ?? '').replaceAll(',', '.')) == null ? l10n.invalid : null,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _proteinController,
                      readOnly: _manualPer100gMode,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: l10n.nutritionProteinLabel),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextFormField(
                      controller: _carbsController,
                      readOnly: _manualPer100gMode,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: l10n.nutritionCarbsLabel),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextFormField(
                      controller: _fatController,
                      readOnly: _manualPer100gMode,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: l10n.nutritionFatLabel),
                    ),
                  ),
                ],
              ),
              CheckboxListTile(
                value: _saveToMyFoods,
                onChanged: (value) => setState(() => _saveToMyFoods = value ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.nutritionSaveFoodOption),
              ),
              const SizedBox(height: AppSpacing.md),
              LiftPrimaryButton(label: l10n.nutritionLogButton, onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
