import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_motion.dart';

class LiftNavDestination {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  const LiftNavDestination({required this.icon, required this.selectedIcon, required this.label});
}

// Replaces Material's NavigationBar pill-indicator pattern: a dark strip
// where the active state is a short violet underline tick plus a label
// weight change, not a filled blob behind the icon.
class LiftNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<LiftNavDestination> destinations;

  const LiftNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.divider)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(destinations.length, (i) {
              final selected = i == selectedIndex;
              final d = destinations[i];
              return Expanded(
                child: InkWell(
                  onTap: () => onDestinationSelected(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: AppMotion.base,
                        curve: AppMotion.enter,
                        width: selected ? 20 : 0,
                        height: 2,
                        margin: const EdgeInsets.only(bottom: 6),
                        color: c.violet,
                      ),
                      Icon(
                        selected ? d.selectedIcon : d.icon,
                        size: 23,
                        color: selected ? c.violet : c.textSecondary,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        d.label,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: selected ? c.violet : c.textSecondary,
                              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                              letterSpacing: 0,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
