import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../database/backup_service.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/database_provider.dart';
import '../../../providers/locale_provider.dart';
import '../../../providers/theme_provider.dart';

const _appVersion = '1.0.0';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _exportBackup(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    try {
      final db = ref.read(appDatabaseProvider);
      final file = await BackupService(db).exportBackup();
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: l10n.backupShareText),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.exportFailed('$e'))));
    }
  }

  Future<void> _restoreBackup(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final picked = await FilePicker.pickFile(
      dialogTitle: l10n.selectBackupFileTitle,
    );
    if (picked?.path == null || !context.mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.restoreBackupDialogTitle),
        content: Text(l10n.restoreBackupDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.restoreButton),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final db = ref.read(appDatabaseProvider);
    await db.close();
    await BackupService.restoreFromFile(File(picked!.path!));

    if (context.mounted) {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          title: Text(l10n.restoreCompleteTitle),
          content: Text(l10n.restoreCompleteContent),
          actions: [
            FilledButton(
              onPressed: () => SystemNavigator.pop(),
              child: Text(l10n.closeAppButton),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          children: [
            Text(l10n.appearanceLabel.toUpperCase(), style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: AppSpacing.md),
            SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text(l10n.themeSystem),
                  icon: const Icon(Icons.brightness_auto),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text(l10n.themeLight),
                  icon: const Icon(Icons.light_mode),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text(l10n.themeDark),
                  icon: const Icon(Icons.dark_mode),
                ),
              ],
              selected: {themeMode},
              onSelectionChanged: (selection) => ref
                  .read(themeModeProvider.notifier)
                  .setThemeMode(selection.first),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            Text(l10n.languageLabel.toUpperCase(), style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: AppSpacing.md),
            SegmentedButton<Locale>(
              segments: [
                ButtonSegment(value: const Locale('en'), label: Text(l10n.languageEnglish)),
                ButtonSegment(value: const Locale('sr'), label: Text(l10n.languageSerbian)),
              ],
              selected: {locale ?? Localizations.localeOf(context)},
              onSelectionChanged: (selection) =>
                  ref.read(localeProvider.notifier).setLocale(selection.first),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            Text(
              l10n.backupRestoreLabel.toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.backupDescription,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: () => _exportBackup(context, ref),
              icon: const Icon(Icons.upload_outlined),
              label: Text(l10n.exportBackupButton),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: () => _restoreBackup(context, ref),
              icon: const Icon(Icons.download_outlined),
              label: Text(l10n.restoreFromBackupButton),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            Text(l10n.aboutLabel.toUpperCase(), style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.appTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(l10n.versionLabel(_appVersion),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.textSecondary)),
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.aboutDescription,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: c.textSecondary)),
          ],
        ),
      ),
    );
  }
}
