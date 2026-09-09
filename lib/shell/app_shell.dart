import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../design/widgets/lift_nav_bar.dart';
import '../l10n/app_localizations.dart';
import 'app_drawer.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      drawer: const AppDrawer(),
      body: navigationShell,
      bottomNavigationBar: LiftNavBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) =>
            navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex),
        destinations: [
          LiftNavDestination(icon: Icons.home_outlined, selectedIcon: Icons.home_rounded, label: l10n.navHome),
          LiftNavDestination(icon: Icons.history_outlined, selectedIcon: Icons.history_rounded, label: l10n.navHistory),
          LiftNavDestination(icon: Icons.fitness_center_outlined, selectedIcon: Icons.fitness_center_rounded, label: l10n.navExercises),
          LiftNavDestination(icon: Icons.bar_chart_outlined, selectedIcon: Icons.bar_chart_rounded, label: l10n.navStats),
          LiftNavDestination(icon: Icons.person_outline, selectedIcon: Icons.person_rounded, label: l10n.navProfile),
        ],
      ),
    );
  }
}
