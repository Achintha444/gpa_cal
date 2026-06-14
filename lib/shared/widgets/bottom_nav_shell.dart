import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gpa_cal/theme/app_colors.dart';
import 'package:gpa_cal/theme/app_spacing.dart';
import 'package:gpa_cal/theme/app_typography.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// The bottom navigation shell for the 3-tab layout (Home, Analytics, Settings).
///
/// Wraps GoRouter's [StatefulNavigationShell] to provide a consistent bottom
/// bar across all primary tabs. Each tab has a label and icon; the active tab
/// uses the accent color and a slightly bolder label weight.
///
/// Register this widget as the shell of a [StatefulShellRoute] in the router:
/// ```dart
/// StatefulShellRoute.indexedStack(
///   builder: (context, state, shell) => BottomNavShell(navigationShell: shell),
///   branches: [...],
/// )
/// ```
class BottomNavShell extends StatelessWidget {
  /// The GoRouter shell that manages the tab branch stack.
  final StatefulNavigationShell navigationShell;

  /// Creates a [BottomNavShell].
  const BottomNavShell({
    super.key,
    required this.navigationShell,
  });

  /// The metadata for each navigation tab.
  static const List<_NavItem> _items = [
    _NavItem(icon: LucideIcons.home, label: 'HOME'),
    _NavItem(icon: LucideIcons.barChart3, label: 'ANALYTICS'),
    _NavItem(icon: LucideIcons.settings, label: 'SETTINGS'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _BottomBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        items: _items,
      ),
    );
  }
}

/// The visual bottom bar rendering all [_NavItem] tabs.
class _BottomBar extends StatelessWidget {
  /// The index of the currently active tab.
  final int currentIndex;

  /// Called when the user taps a tab, passing the new index.
  final ValueChanged<int> onTap;

  /// The list of tab metadata items.
  final List<_NavItem> items;

  /// Creates a [_BottomBar].
  const _BottomBar({
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 80,
          child: Row(
            children: List.generate(items.length, (int index) {
              final bool isActive = index == currentIndex;
              return Expanded(
                child: _NavTabButton(
                  item: items[index],
                  isActive: isActive,
                  onTap: () => onTap(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

/// A single tappable tab within the bottom navigation bar.
class _NavTabButton extends StatelessWidget {
  /// The metadata for this tab.
  final _NavItem item;

  /// Whether this tab is currently active.
  final bool isActive;

  /// Called when this tab is tapped.
  final VoidCallback onTap;

  /// Creates a [_NavTabButton].
  const _NavTabButton({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color color =
        isActive ? AppColors.accent : AppColors.textPlaceholder;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(item.icon, size: 20, color: color),
          const SizedBox(height: AppSpacing.space4),
          Text(
            item.label,
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontWeight:
                  isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Metadata for a single bottom navigation tab.
class _NavItem {
  /// The icon displayed for this tab.
  final IconData icon;

  /// The uppercase label displayed below the icon.
  final String label;

  /// Creates a [_NavItem].
  const _NavItem({required this.icon, required this.label});
}
