import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/enums.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/lift_button.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/food_log_providers.dart';

// Shared by every add-food path (manual, barcode, search, photo) — later
// stages prefill these fields from an external source, but everything stays
// directly editable so a bad API value is never a dead end.
class ConfirmFoodSheet extends ConsumerStatefulWidget {
  final String? initialName;
  final String? initialQuantityLabel;
  final double? initialCalories;
  final double? initialProteinG;
  final double? initialCarbsG;
  final double? initialFatG;
  final FoodLogSource source;
  final String? sourceId;

  const ConfirmFoodSheet({
    super.key,
    this.initialName,
    this.initialQuantityLabel,
    this.initialCalories,
    this.initialProteinG,
    this.initialCarbsG,
    this.initialFatG,
    this.source = FoodLogSource.manual,
    this.sourceId,
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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _quantityController = TextEditingController(text: widget.initialQuantityLabel ?? '');
    _caloriesController =
        TextEditingController(text: widget.initialCalories?.round().toString() ?? '');
    _proteinController =
        TextEditingController(text: widget.initialProteinG?.round().toString() ?? '');
    _carbsController = TextEditingController(text: widget.initialCarbsG?.round().toString() ?? '');
    _fatController = TextEditingController(text: widget.initialFatG?.round().toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  double _num(TextEditingController c) => double.tryParse(c.text.replaceAll(',', '.')) ?? 0;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(foodLogControllerProvider).logEntry(
          name: _nameController.text.trim(),
          quantityLabel: _quantityController.text.trim(),
          calories: _num(_caloriesController),
          proteinG: _num(_proteinController),
          carbsG: _num(_carbsController),
          fatG: _num(_fatController),
          source: widget.source,
          sourceId: widget.sourceId,
        );
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
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
              TextFormField(
                controller: _nameController,
                autofocus: widget.initialName == null,
                decoration: InputDecoration(labelText: l10n.nutritionFoodNameLabel),
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? l10n.enterAName : null,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: l10n.nutritionQuantityLabel),
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? l10n.enterAName : null,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _caloriesController,
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
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: l10n.nutritionProteinLabel),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextFormField(
                      controller: _carbsController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: l10n.nutritionCarbsLabel),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextFormField(
                      controller: _fatController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: l10n.nutritionFatLabel),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              LiftPrimaryButton(label: l10n.nutritionLogButton, onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
