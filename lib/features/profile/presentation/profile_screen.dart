import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/enums.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/profile_providers.dart';
import 'edit_profile_sheet.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  int? _ageFrom(DateTime? birthDate) {
    if (birthDate == null) return null;
    final now = DateTime.now();
    var age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => EditProfileSheet(existing: profileAsync.value),
            ),
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text(l10n.errorMessage('$error'))),
        data: (profile) {
          final age = _ageFrom(profile?.birthDate);

          final rows = <String>[
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
              Divider(height: 1, color: c.divider),
              ...rows.map((row) => Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(row, style: theme.textTheme.bodyMedium),
                        ),
                      ),
                      Divider(height: 1, color: c.divider),
                    ],
                  )),
            ],
          );
        },
      ),
    );
  }
}
