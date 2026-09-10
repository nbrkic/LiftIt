import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/date_utils.dart';
import '../../../common/number_format_utils.dart';
import '../../../database/enums.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/profile_providers.dart';
import 'edit_nutrition_goals_sheet.dart';
import 'edit_profile_sheet.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final theme = Theme.of(context);
    final profileAsync = ref.watch(userProfileProvider);
    final unit = ref.watch(preferredWeightUnitProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text(l10n.errorMessage('$error'))),
        data: (profile) {
          final age = ageFrom(profile?.birthDate);

          final basicRows = <String>[
            if (age != null) l10n.ageLabel(age),
            if (profile?.gender != null) l10n.genderValueLabel(profile!.gender!.label(context)),
            if (profile?.heightCm != null) l10n.heightValueLabel('${profile!.heightCm}'),
            if (profile?.experienceLevel != null)
              l10n.experienceValueLabel(profile!.experienceLevel!.label(context)),
            if (profile?.primaryGoal != null)
              l10n.goalValueLabel(profile!.primaryGoal!.label(context)),
            if (profile?.weeklyTrainingGoal != null)
              l10n.weeklyGoalValueLabel(profile!.weeklyTrainingGoal!),
            l10n.preferredUnitValueLabel(unit.label(context)),
          ];

          final nutritionRows = <String>[
            if (profile?.dailyCalorieGoal != null)
              l10n.dailyCalorieGoalValueLabel(profile!.dailyCalorieGoal!),
            if (profile?.dailyProteinGoalG != null)
              l10n.dailyProteinGoalValueLabel(profile!.dailyProteinGoalG!),
            if (profile?.dailyCarbsGoalG != null)
              l10n.dailyCarbsGoalValueLabel(profile!.dailyCarbsGoalG!),
            if (profile?.dailyFatGoalG != null)
              l10n.dailyFatGoalValueLabel(profile!.dailyFatGoalG!),
            if (profile?.dailyWaterGoalMl != null)
              l10n.dailyWaterGoalValueLabel(formatLiters(profile!.dailyWaterGoalMl!)),
          ];

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            children: [
              Text(
                profile?.name?.isNotEmpty == true ? profile!.name! : l10n.noNameSet,
                style: theme.textTheme.displaySmall,
              ),
              if (profile == null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(l10n.tapEditToFillProfile,
                    style: theme.textTheme.bodyMedium?.copyWith(color: c.textSecondary)),
              ],
              const SizedBox(height: AppSpacing.xxl),
              _SectionHeader(
                label: l10n.basicInfoSectionLabel,
                onEdit: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => EditProfileSheet(existing: profile),
                ),
              ),
              Divider(height: 1, color: c.divider),
              ...basicRows.map((row) => _ProfileRow(text: row)),
              const SizedBox(height: AppSpacing.xxl),
              _SectionHeader(
                label: l10n.nutritionGoalsSectionLabel,
                onEdit: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => EditNutritionGoalsSheet(existing: profile),
                ),
              ),
              Divider(height: 1, color: c.divider),
              if (nutritionRows.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Text(l10n.noNutritionGoalsSet,
                      style: theme.textTheme.bodyMedium?.copyWith(color: c.textSecondary)),
                )
              else
                ...nutritionRows.map((row) => _ProfileRow(text: row)),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final VoidCallback onEdit;

  const _SectionHeader({required this.label, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label.toUpperCase(), style: Theme.of(context).textTheme.labelMedium),
        IconButton(
          icon: const Icon(Icons.edit_outlined, size: 20),
          onPressed: onEdit,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final String text;

  const _ProfileRow({required this.text});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
        Divider(height: 1, color: c.divider),
      ],
    );
  }
}
