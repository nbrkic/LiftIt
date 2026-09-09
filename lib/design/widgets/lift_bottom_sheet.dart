import 'package:flutter/material.dart';
import '../tokens/app_spacing.dart';

// Shared sheet chrome: consistent title treatment and padding that correctly
// accounts for both the keyboard (viewInsets) and the system nav bar
// (padding) — see the nav-bar-overlap fix already applied across the app's
// existing sheets. New/redesigned sheets should build on this instead of
// hand-rolling Padding+Form each time.
class LiftBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;

  const LiftBottomSheet({super.key, this.title, required this.child});

  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required WidgetBuilder builder,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => LiftBottomSheet(title: title, child: builder(ctx)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.xxl,
        right: AppSpacing.xxl,
        top: AppSpacing.xl,
        bottom: MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).padding.bottom +
            AppSpacing.xxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            Text(title!, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.lg),
          ],
          child,
        ],
      ),
    );
  }
}
