import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              child: Row(
                children: [
                  Icon(Icons.fitness_center, size: 32, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 12),
                  Text('LiftIt', style: Theme.of(context).textTheme.headlineSmall),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_view_week_outlined),
              title: const Text('Splits'),
              onTap: () {
                Navigator.of(context).pop();
                context.push('/splits');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
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
