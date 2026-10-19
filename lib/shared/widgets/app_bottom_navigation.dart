import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Shared bottom navigation.
class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.unreadCount,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    final alertIcon = unreadCount > 0
        ? Badge(
            label: Text(unreadCount > 9 ? '9+' : '$unreadCount'),
            child: const Icon(Icons.notifications_outlined),
          )
        : const Icon(Icons.notifications_outlined);
    final alertSelected = unreadCount > 0
        ? Badge(
            label: Text(unreadCount > 9 ? '9+' : '$unreadCount'),
            child: const Icon(Icons.notifications),
          )
        : const Icon(Icons.notifications);

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        const NavigationDestination(
          icon: Icon(Icons.map_outlined),
          selectedIcon: Icon(Icons.map),
          label: 'Track',
        ),
        const NavigationDestination(
          icon: IconTheme(
            data: IconThemeData(color: AppColors.red),
            child: Icon(Icons.shield_outlined),
          ),
          selectedIcon: IconTheme(
            data: IconThemeData(color: AppColors.red),
            child: Icon(Icons.shield),
          ),
          label: 'Security',
        ),
        NavigationDestination(
          icon: alertIcon,
          selectedIcon: alertSelected,
          label: 'Alerts',
        ),
        const NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
