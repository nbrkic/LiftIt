import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/app_database.dart';
import '../../../database/enums.dart';
import '../providers/profile_providers.dart';
import '../providers/stats_providers.dart';
import '../utils/volume_stats.dart';
import 'edit_profile_sheet.dart';
import 'log_bodyweight_sheet.dart';

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
    final latestWeightAsync = ref.watch(latestBodyweightProvider);
    final historyAsync = ref.watch(bodyweightHistoryProvider);
    final sessionVolumesAsync = ref.watch(sessionVolumesProvider);

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
          final unit = profile?.preferredWeightUnit;

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
                      if (unit != null) Text('Preferred unit: ${unit.label}'),
                      if (profile == null)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text('Tap the edit icon to fill in your profile.'),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Training Volume (weekly)', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              sessionVolumesAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (error, stack) => const SizedBox.shrink(),
                data: (sessions) {
                  final weeks = computeWeeklyVolume(sessions);
                  if (weeks.every((w) => w.volume == 0)) {
                    return const Text('No completed workouts yet');
                  }
                  return SizedBox(height: 160, child: _VolumeChart(weeks: weeks));
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Bodyweight', style: Theme.of(context).textTheme.titleMedium),
                  FilledButton.tonalIcon(
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => const LogBodyweightSheet(),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Log Weigh-in'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              latestWeightAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (error, stack) => const SizedBox.shrink(),
                data: (latest) => Text(
                  latest == null ? 'No weigh-ins yet' : 'Current: ${latest.weightKg} kg',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 12),
              historyAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (error, stack) => const SizedBox.shrink(),
                data: (history) {
                  if (history.length < 2) return const SizedBox.shrink();
                  final ascending = history.reversed.toList();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SizedBox(height: 180, child: _BodyweightChart(entries: ascending)),
                  );
                },
              ),
              historyAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (error, stack) => const SizedBox.shrink(),
                data: (history) {
                  if (history.isEmpty) return const SizedBox.shrink();
                  return Column(
                    children: history
                        .map((entry) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text('${entry.weightKg} kg'),
                              subtitle: Text(_formatDate(entry.loggedAt)),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => ref
                                    .read(profileControllerProvider)
                                    .deleteBodyweightLog(entry.id),
                              ),
                            ))
                        .toList(),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}

class _VolumeChart extends StatelessWidget {
  final List<WeeklyVolume> weeks;

  const _VolumeChart({required this.weeks});

  @override
  Widget build(BuildContext context) {
    final maxVolume = weeks.map((w) => w.volume).fold(0.0, (a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        maxY: maxVolume == 0 ? 1 : maxVolume * 1.2,
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              getTitlesWidget: (value, meta) {
                final index = value.round();
                if (index < 0 || index >= weeks.length) return const SizedBox.shrink();
                final date = weeks[index].weekStart;
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('${date.day}.${date.month}.', style: const TextStyle(fontSize: 10)),
                );
              },
            ),
          ),
        ),
        barGroups: weeks
            .asMap()
            .entries
            .map((e) => BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value.volume,
                      color: Theme.of(context).colorScheme.primary,
                      width: 16,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }
}

class _BodyweightChart extends StatelessWidget {
  final List<BodyweightLog> entries; // ascending by loggedAt — one point per entry

  const _BodyweightChart({required this.entries});

  @override
  Widget build(BuildContext context) {
    final spots = entries
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.weightKg))
        .toList();
    final minWeight = entries.map((e) => e.weightKg).reduce((a, b) => a < b ? a : b);
    final maxWeight = entries.map((e) => e.weightKg).reduce((a, b) => a > b ? a : b);
    final padding = ((maxWeight - minWeight) * 0.15).clamp(1.0, double.infinity);

    return LineChart(
      LineChartData(
        minY: minWeight - padding,
        maxY: maxWeight + padding,
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              interval: (entries.length / 4).clamp(1, double.infinity).roundToDouble(),
              getTitlesWidget: (value, meta) {
                final index = value.round();
                if (index < 0 || index >= entries.length) return const SizedBox.shrink();
                final date = entries[index].loggedAt;
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('${date.day}.${date.month}.', style: const TextStyle(fontSize: 10)),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) => touchedSpots
                .map((spot) => LineTooltipItem(
                      '${entries[spot.x.toInt()].weightKg} kg',
                      const TextStyle(fontWeight: FontWeight.bold),
                    ))
                .toList(),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 3,
            color: Theme.of(context).colorScheme.primary,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
            ),
          ),
        ],
      ),
    );
  }
}
