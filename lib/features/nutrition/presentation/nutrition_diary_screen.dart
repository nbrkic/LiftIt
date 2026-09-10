import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/date_utils.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/empty_state.dart';
import '../../../design/widgets/stat_block.dart';
import '../../../l10n/app_localizations.dart';
import '../../profile/providers/profile_providers.dart';
import '../providers/food_log_providers.dart';
import 'confirm_food_sheet.dart';

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

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final entriesAsync = ref.watch(foodLogForDayProvider(_selectedDay));
    final totals = ref.watch(dailyNutritionTotalsProvider(_selectedDay));
    final profile = ref.watch(userProfileProvider).value;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.nutritionTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => const ConfirmFoodSheet(),
        ),
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
                            Text(
                              '${entry.calories.round()}',
                              style: theme.textTheme.titleMedium,
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

  const _StatWithProgress({
    required this.value,
    required this.label,
    required this.current,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final overLimit = goal != null && goal! > 0 && current > goal!;
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
