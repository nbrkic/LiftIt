import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/progress_photo_providers.dart';

class ProgressPhotoDetailScreen extends ConsumerWidget {
  final int photoId;

  const ProgressPhotoDetailScreen({super.key, required this.photoId});

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteProgressPhotoDialogTitle),
        content: Text(l10n.deleteProgressPhotoDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.deleteButton),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(progressPhotoControllerProvider).deletePhoto(photoId);
    if (context.mounted) Navigator.of(context).pop();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photo = ref.watch(progressPhotoByIdProvider(photoId)).value;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(photo != null ? _formatDate(photo.takenAt) : ''),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _delete(context, ref),
          ),
        ],
      ),
      body: photo == null
          ? const SizedBox.shrink()
          : SafeArea(
              top: false,
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: InteractiveViewer(
                        child: Image.memory(Uint8List.fromList(photo.imageBytes)),
                      ),
                    ),
                  ),
                  if (photo.aiSummary != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.xxl),
                      color: Colors.black,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.progressPhotoAiSummaryLabel.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(photo.aiSummary!, style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
