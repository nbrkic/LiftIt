import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/enums.dart';
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

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile?.name?.isNotEmpty == true ? profile!.name! : l10n.noNameSet,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      if (age != null) Text(l10n.ageLabel(age)),
                      if (profile?.gender != null) Text(l10n.genderValueLabel(profile!.gender!.label(context))),
                      if (profile?.heightCm != null) Text(l10n.heightValueLabel('${profile!.heightCm}')),
                      if (profile?.experienceLevel != null)
                        Text(l10n.experienceValueLabel(profile!.experienceLevel!.label(context))),
                      if (profile?.primaryGoal != null)
                        Text(l10n.goalValueLabel(profile!.primaryGoal!.label(context))),
                      if (profile?.weeklyTrainingGoal != null)
                        Text(l10n.weeklyGoalValueLabel(profile!.weeklyTrainingGoal!)),
                      Text(l10n.preferredUnitValueLabel(unit.label(context))),
                      if (profile == null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(l10n.tapEditToFillProfile),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
