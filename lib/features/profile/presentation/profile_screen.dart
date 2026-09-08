import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/enums.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
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
        error: (error, stack) => Center(child: Text('Error: $error')),
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
                        profile?.name?.isNotEmpty == true ? profile!.name! : 'No name set',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      if (age != null) Text('Age: $age'),
                      if (profile?.gender != null) Text('Gender: ${profile!.gender!.label}'),
                      if (profile?.heightCm != null) Text('Height: ${profile!.heightCm} cm'),
                      if (profile?.experienceLevel != null)
                        Text('Experience: ${profile!.experienceLevel!.label}'),
                      if (profile?.primaryGoal != null)
                        Text('Goal: ${profile!.primaryGoal!.label}'),
                      if (profile?.weeklyTrainingGoal != null)
                        Text('Weekly goal: ${profile!.weeklyTrainingGoal} days'),
                      Text('Preferred unit: ${unit.label}'),
                      if (profile == null)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text('Tap the edit icon to fill in your profile.'),
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
