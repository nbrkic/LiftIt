import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_radius.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/empty_state.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/api_keys_provider.dart';
import '../providers/progress_photo_providers.dart';

class ProgressPhotosScreen extends ConsumerWidget {
  const ProgressPhotosScreen({super.key});

  Future<void> _addPhoto(BuildContext context, WidgetRef ref, ImageSource source) async {
    // Deliberately uncompressed/full-resolution, unlike the Gemini
    // recognition flow — these are kept for visual comparison over time,
    // where quality matters more than the extra SQLite storage it costs.
    final file = await ImagePicker().pickImage(source: source);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    final id = await ref.read(progressPhotoControllerProvider).addPhoto(imageBytes: bytes);
    if (!context.mounted) return;

    final apiKey = (await ref.read(apiKeysProvider.notifier).ensureGeminiApiKey()).trim();
    if (!context.mounted || apiKey.isEmpty) return;
    final languageName = Localizations.localeOf(context).languageCode == 'sr' ? 'Serbian' : 'English';
    // Deliberately not awaited — must never hold up the gallery/add flow.
    ref.read(progressPhotoControllerProvider).generateComparisonSummary(
          newPhotoId: id,
          newPhotoBytes: bytes,
          apiKey: apiKey,
          languageName: languageName,
        );
  }

  Future<void> _showAddPhotoSheet(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final c = context.colors;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.xxl,
          right: AppSpacing.xxl,
          top: AppSpacing.xl,
          bottom: MediaQuery.of(sheetContext).padding.bottom + AppSpacing.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.progressPhotoAddTitle, style: Theme.of(sheetContext).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.lg),
            _SourceOption(
              icon: Icons.camera_alt_outlined,
              label: l10n.progressPhotoTakeAction,
              onTap: () => Navigator.of(sheetContext).pop(ImageSource.camera),
            ),
            Divider(height: 1, color: c.divider),
            _SourceOption(
              icon: Icons.photo_library_outlined,
              label: l10n.progressPhotoChooseAction,
              onTap: () => Navigator.of(sheetContext).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null || !context.mounted) return;
    await _addPhoto(context, ref, source);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final photosAsync = ref.watch(progressPhotosProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.progressPhotosTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPhotoSheet(context, ref),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        top: false,
        child: photosAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text(l10n.errorMessage('$error'))),
          data: (photos) {
            if (photos.isEmpty) {
              return LiftEmptyState(message: l10n.progressPhotosEmpty);
            }
            return GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: AppSpacing.sm,
                mainAxisSpacing: AppSpacing.sm,
              ),
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final photo = photos[index];
                return InkWell(
                  borderRadius: AppRadius.smRadius,
                  onTap: () => context.push('/progress-photos/${photo.id}'),
                  child: ClipRRect(
                    borderRadius: AppRadius.smRadius,
                    child: Image.memory(
                      Uint8List.fromList(photo.imageBytes),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _SourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SourceOption({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            Icon(icon, size: 22, color: c.violet),
            const SizedBox(width: AppSpacing.lg),
            Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
