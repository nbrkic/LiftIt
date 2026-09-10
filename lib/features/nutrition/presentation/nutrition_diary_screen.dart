import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common/date_utils.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/empty_state.dart';
import '../../../design/widgets/stat_block.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/api_keys_provider.dart';
import '../../profile/presentation/edit_nutrition_goals_sheet.dart';
import '../../profile/providers/profile_providers.dart';
import '../providers/food_log_providers.dart';
import '../providers/supplement_providers.dart';
import '../providers/water_log_providers.dart';
import '../services/gemini_service.dart';
import 'add_food_sheet.dart';

class NutritionDiaryScreen extends ConsumerStatefulWidget {
  const NutritionDiaryScreen({super.key});

  @override
  ConsumerState<NutritionDiaryScreen> createState() => _NutritionDiaryScreenState();
}

class _NutritionDiaryScreenState extends ConsumerState<NutritionDiaryScreen> {
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = dayOf(DateTime.now());
  }

  bool get _isToday => _selectedDay == dayOf(DateTime.now());

  void _goToPreviousDay() {
    setState(() => _selectedDay = _selectedDay.subtract(const Duration(days: 1)));
  }

  void _goToNextDay() {
    if (_isToday) return;
    setState(() => _selectedDay = _selectedDay.add(const Duration(days: 1)));
  }

  Future<void> _pickDay(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDay,
      firstDate: DateTime(2020),
      lastDate: dayOf(DateTime.now()),
    );
    if (picked != null) setState(() => _selectedDay = dayOf(picked));
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteFoodDialogTitle),
        content: Text(l10n.deleteFoodDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.deleteButton),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  String _formatDay(DateTime day) {
    return '${day.day.toString().padLeft(2, '0')}.${day.month.toString().padLeft(2, '0')}.${day.year}';
  }

  Future<void> _addFood(BuildContext context) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const AddFoodSheet(),
    );
    if (choice == 'photo' && context.mounted) {
      await _pickAndAnalyzePhoto(context);
    }
  }

  Future<void> _pickAndAnalyzePhoto(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final apiKey = ref.read(apiKeysProvider).geminiApiKey.trim();
    if (apiKey.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.nutritionGeminiKeyMissing)));
      return;
    }

    // Downscale before it's even read into bytes — a full-resolution phone
    // photo can be several MB, which made base64-encoding + upload alone
    // slow enough to blow past the request timeout. Food recognition
    // doesn't need more than this to work.
    final file = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    if (file == null || !context.mounted) return;
    final bytes = await file.readAsBytes();
    if (!context.mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: AppSpacing.lg),
            Expanded(child: Text(l10n.nutritionAiProcessing)),
          ],
        ),
      ),
    );

    try {
      final items = await GeminiService().recognizeFood(bytes, apiKey);
      if (!context.mounted) return;
      Navigator.of(context).pop(); // dismiss the analyzing dialog
      if (items.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.nutritionNoItemsRecognized)));
        return;
      }
      context.push('/nutrition/photo-results', extra: items);
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop(); // dismiss the analyzing dialog
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.errorMessage('$e'))));
    }
  }

  Future<void> _addWater(int amountMl) async {
    await ref.read(waterLogControllerProvider).addWater(amountMl);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final entriesAsync = ref.watch(foodLogForDayProvider(_selectedDay));
    final totals = ref.watch(dailyNutritionTotalsProvider(_selectedDay));
    final profile = ref.watch(userProfileProvider).value;
    final waterEntries = ref.watch(waterLogForDayProvider(_selectedDay)).value ?? const [];
    final waterTotalMl = ref.watch(dailyWaterTotalMlProvider(_selectedDay));
    final supplements = ref.watch(supplementsProvider).value ?? const [];
    final takenSupplementIds = ref.watch(takenSupplementIdsProvider(_selectedDay));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.nutritionTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.medication_outlined),
            tooltip: l10n.nutritionManageSupplementsAction,
            onPressed: () => context.push('/nutrition/supplements'),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: l10n.editNutritionGoalsTitle,
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => EditNutritionGoalsSheet(existing: profile),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addFood(context),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _goToPreviousDay,
                ),
                InkWell(
                  onTap: () => _pickDay(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    child: Text(
                      _isToday ? l10n.nutritionTodayLabel : _formatDay(_selectedDay),
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _isToday ? null : _goToNextDay,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _StatWithProgress(
                    value: '${totals.calories.round()}',
                    label: l10n.nutritionCaloriesLabel,
                    current: totals.calories,
                    goal: profile?.dailyCalorieGoal,
                  ),
                ),
                const SizedBox(width: AppSpacing.xl),
                Expanded(
                  child: _StatWithProgress(
                    value: '${totals.proteinG.round()}g',
                    label: l10n.nutritionProteinLabel,
                    current: totals.proteinG,
                    goal: profile?.dailyProteinGoalG,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _StatWithProgress(
                    value: '${totals.carbsG.round()}g',
                    label: l10n.nutritionCarbsLabel,
                    current: totals.carbsG,
                    goal: profile?.dailyCarbsGoalG,
                  ),
                ),
                const SizedBox(width: AppSpacing.xl),
                Expanded(
                  child: _StatWithProgress(
                    value: '${totals.fatG.round()}g',
                    label: l10n.nutritionFatLabel,
                    current: totals.fatG,
                    goal: profile?.dailyFatGoalG,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            _StatWithProgress(
              value: '$waterTotalMl ml',
              label: l10n.nutritionWaterLabel,
              current: waterTotalMl.toDouble(),
              goal: profile?.dailyWaterGoalMl,
              warnOverGoal: false,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _WaterQuickAddButton(label: '+100 ml', onTap: () => _addWater(100)),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _WaterQuickAddButton(label: '+250 ml', onTap: () => _addWater(250)),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _WaterQuickAddButton(label: '+500 ml', onTap: () => _addWater(500)),
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton(
                  icon: const Icon(Icons.undo),
                  tooltip: l10n.nutritionUndoWaterAction,
                  onPressed: waterEntries.isEmpty
                      ? null
                      : () => ref.read(waterLogControllerProvider).deleteEntry(waterEntries.first.id),
                ),
              ],
            ),
            if (supplements.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xl),
              Text(l10n.nutritionSupplementsLabel.toUpperCase(),
                  style: theme.textTheme.labelMedium),
              const SizedBox(height: AppSpacing.sm),
              ...supplements.map((supplement) {
                final taken = takenSupplementIds.contains(supplement.id);
                return CheckboxListTile(
                  value: taken,
                  onChanged: (value) => ref.read(supplementControllerProvider).setTaken(
                        supplementId: supplement.id,
                        day: _selectedDay,
                        taken: value ?? false,
                      ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: Text('${supplement.name} ${supplement.dosageLabel}'),
                );
              }),
            ],
            const SizedBox(height: AppSpacing.xxxl),
            entriesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text(l10n.errorMessage('$error')),
              data: (entries) {
                if (entries.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
                    child: LiftEmptyState(message: l10n.nutritionEmptyDay),
                  );
                }
                return Column(
                  children: entries.map((entry) {
                    return Dismissible(
                      key: ValueKey(entry.id),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (_) => _confirmDelete(context),
                      onDismissed: (_) =>
                          ref.read(foodLogControllerProvider).deleteEntry(entry.id),
                      background: Container(
                        color: c.danger.withValues(alpha: 0.15),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: AppSpacing.lg),
                        child: Icon(Icons.delete_outline, color: c.danger),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                        child: Row(
                          children: [
                            Container(width: 3, height: 34, color: c.violet),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(entry.name, style: theme.textTheme.bodyLarge),
                                  Text(
                                    entry.quantityLabel,
                                    style: theme.textTheme.bodySmall?.copyWith(color: c.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${entry.calories.round()}',
                                  style: theme.textTheme.titleMedium,
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                Text(
                                  l10n.nutritionCaloriesUnitShort,
                                  style: theme.textTheme.bodySmall?.copyWith(color: c.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatWithProgress extends StatelessWidget {
  final String value;
  final String label;
  final double current;
  final int? goal;
  // Going over a calorie/macro goal is worth flagging red; going over a
  // water goal is just fine, so that widget passes false here.
  final bool warnOverGoal;

  const _StatWithProgress({
    required this.value,
    required this.label,
    required this.current,
    required this.goal,
    this.warnOverGoal = true,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final overLimit = warnOverGoal && goal != null && goal! > 0 && current > goal!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatBlock(value: value, label: label),
        if (goal != null && goal! > 0) ...[
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: (current / goal!).clamp(0, 1),
              minHeight: 4,
              color: overLimit ? Color.lerp(c.danger, Colors.black, 0.3) : c.violet,
              backgroundColor: c.divider,
            ),
          ),
        ],
      ],
    );
  }
}

class _WaterQuickAddButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _WaterQuickAddButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: c.violet,
        side: BorderSide(color: c.violet),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      ),
      child: Text(label),
    );
  }
}
