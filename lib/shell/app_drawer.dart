import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../design/tokens/app_colors.dart';
import '../design/tokens/app_spacing.dart';
import '../l10n/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Drawer(
      backgroundColor: c.background,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.xxxl, AppSpacing.xxl, AppSpacing.xl),
              child: Text(l10n.appTitle, style: theme.textTheme.displaySmall),
            ),
            Divider(height: 1, color: c.divider),
            const SizedBox(height: AppSpacing.sm),
            _DrawerItem(
              icon: Icons.calendar_view_week_outlined,
              label: l10n.drawerSplits,
              onTap: () {
                Navigator.of(context).pop();
                context.push('/splits');
              },
            ),
            _DrawerItem(
              icon: Icons.monitor_weight_outlined,
              label: l10n.drawerBodyweight,
              onTap: () {
                Navigator.of(context).pop();
                context.push('/bodyweight');
              },
            ),
            _DrawerItem(
              icon: Icons.settings_outlined,
              label: l10n.drawerSettings,
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

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.md),
        child: Row(
          children: [
            Icon(icon, size: 22, color: c.textSecondary),
            const SizedBox(width: AppSpacing.lg),
            Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
