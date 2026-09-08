import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              child: Row(
                children: [
                  Icon(Icons.fitness_center, size: 32, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 12),
                  Text(l10n.appTitle, style: Theme.of(context).textTheme.headlineSmall),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_view_week_outlined),
              title: Text(l10n.drawerSplits),
              onTap: () {
                Navigator.of(context).pop();
                context.push('/splits');
              },
            ),
            ListTile(
              leading: const Icon(Icons.monitor_weight_outlined),
              title: Text(l10n.drawerBodyweight),
              onTap: () {
                Navigator.of(context).pop();
                context.push('/bodyweight');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: Text(l10n.drawerSettings),
              onTap: () {
                Navigator.of(context).pop();
                context.push('/settings');
              },
            ),
          ],
        ),
      ),
    );
  }
}
