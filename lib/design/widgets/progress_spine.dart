import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';

// Signature motif #4 — a thin vertical violet line connecting sequential
// entries (sessions in the training journal, sets within a group) to
// reinforce "continuous training record" rather than a flat disconnected list.
class ProgressSpine extends StatelessWidget {
  final List<Widget> children;

  const ProgressSpine({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      children: [
        for (var i = 0; i < children.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          width: 2,
                          color: i == 0 ? Colors.transparent : c.violet.withValues(alpha: 0.25),
                        ),
                      ),
                      Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(color: c.violet, shape: BoxShape.circle),
                      ),
                      Expanded(
                        child: Container(
                          width: 2,
                          color: i == children.length - 1
                              ? Colors.transparent
                              : c.violet.withValues(alpha: 0.25),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: children[i]),
              ],
            ),
          ),
      ],
    );
  }
}
