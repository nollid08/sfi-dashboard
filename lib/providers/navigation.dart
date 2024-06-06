import 'package:animated_sidebar/animated_sidebar.dart';
import 'package:dashboard/models/screen_item.dart';
import 'package:dashboard/views/screens/admin_tools/admin_tools.dart';
import 'package:dashboard/views/screens/my_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Create a Riverpod Provider for the screens data
final screensProvider = Provider<List<ScreenItem>>((ref) {
  // Replace with your actual list of screens
  return [
    ScreenItem(
      '/',
      title: 'My Calendar',
      content: const MyCalendar(),
      icon: Icons.calendar_today,
    ),
    ScreenItem(
      '/profile',
      title: 'My Profile',
      content: Placeholder(),
      icon: Icons.person,
    ),
    ScreenItem(
      '/settings',
      title: 'My Settings',
      content: Placeholder(),
      icon: Icons.settings,
    ),
    ScreenItem(
      '/adminTools',
      title: 'Admin Tools',
      content: const AdminTools(),
      icon: Icons.handyman,
      isDesktopOnly: true,
      children: [
        ScreenItem(
          '/adminTools/manageCoaches',
          title: 'Manage Coaches',
          content: Placeholder(),
          icon: Icons.people,
        ),
        ScreenItem(
          '/adminTools/manualBooking',
          title: 'Manual Booking',
          content: Placeholder(),
          icon: Icons.note,
        ),
      ],
    )
  ];
});

final indexedScreensProvider = Provider<List<ScreenItem>>((ref) {
  final screens = ref.watch(screensProvider);
  List<ScreenItem> indexedScreens = [];
  for (ScreenItem screen in screens) {
    indexedScreens.add(screen);
    if (screen.children != null) {
      indexedScreens.addAll(screen.children!);
    }
  }
  return indexedScreens;
});

final sideBarItemsProvider = Provider<List<SidebarItem>>((ref) {
  final screens = ref.watch(screensProvider);
  List<SidebarItem> items = screens.map((ScreenItem screenItem) {
    List<SidebarChildItem>? children = [];
    if (screenItem.children != null) {
      children = screenItem.children!.map((child) {
        return SidebarChildItem(
          text: child.title,
          icon: child.icon,
        );
      }).toList();
    }
    return SidebarItem(
      text: screenItem.title,
      icon: screenItem.icon,
      children: children,
    );
  }).toList();
  return items;
});

final navigationDestinationsProvider =
    Provider<List<NavigationDestination>>((ref) {
  final screens = ref.watch(screensProvider);
  return screens
      .map((screen) {
        if (!screen.isDesktopOnly) {
          return NavigationDestination(
            icon: Icon(screen.icon),
            label: screen.title,
          );
        }
      })
      .whereType<NavigationDestination>()
      .toList();
});

// Another provider to store the selected screen index
final selectedScreenIndexProvider = StateProvider<int>((ref) => 0);

void navigateToScreenByRouteName(
    BuildContext context, WidgetRef ref, String route) {
  final List<ScreenItem> indexedScreens = ref.watch(indexedScreensProvider);
  final ScreenItem screen =
      indexedScreens.firstWhere((screen) => screen.route == route);
  final int index = indexedScreens.indexOf(screen);
  ref.read(selectedScreenIndexProvider.notifier).state = index;
  GoRouter.of(context).go(screen.route);
}

void navigateToScreenByRouteIndex(
    BuildContext context, WidgetRef ref, int index) {
  final List<ScreenItem> indexedScreens = ref.watch(indexedScreensProvider);
  final ScreenItem screen = indexedScreens[index];
  ref.read(selectedScreenIndexProvider.notifier).state = index;
  GoRouter.of(context).go(screen.route);
}
