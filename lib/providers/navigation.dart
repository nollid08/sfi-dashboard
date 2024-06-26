import 'package:animated_sidebar/animated_sidebar.dart';
import 'package:dashboard/models/screen_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Provider for the screens that will be displayed in the navigation bar
final screensProvider = Provider<List<ScreenItem>>((ref) {
  return [
    ScreenItem(
      '/myCalendar',
      title: 'My Calendar',
      icon: Icons.calendar_today,
      activeRouteIdentifier: '/myCalendar',
    ),
    ScreenItem(
      '/myProfile',
      title: 'My Profile',
      icon: Icons.person,
      activeRouteIdentifier: '/myProfile',
    ),
    ScreenItem(
      '/mySettings',
      title: 'My Settings',
      icon: Icons.settings,
      activeRouteIdentifier: '/mySettings',
    ),
    ScreenItem(
      '/adminTools',
      title: 'Admin Tools',
      icon: Icons.admin_panel_settings,
      activeRouteIdentifier: '/adminTools',
      isDesktopOnly: true,
      children: [
        ScreenItem(
          '/adminTools/manageActivities',
          title: 'Manage Activities',
          icon: Icons.sports_soccer,
          activeRouteIdentifier: '/adminTools/manageActivities',
        ),
        ScreenItem(
          '/adminTools/manageClients',
          title: 'Manage Clients',
          icon: Icons.group,
          activeRouteIdentifier: '/adminTools/manageClients',
        ),
        ScreenItem(
          '/adminTools/manageCoaches',
          title: 'Manage Coaches',
          icon: Icons.badge,
          activeRouteIdentifier: '/adminTools/manageCoaches',
        ),
        ScreenItem(
          '/adminTools/resourceView',
          title: 'Resource View',
          icon: Icons.view_list,
          activeRouteIdentifier: '/adminTools/resourceView',
        ),
        ScreenItem(
          '/adminTools/createManualBooking',
          title: 'Create Manual Booking',
          icon: Icons.add,
          activeRouteIdentifier: '/adminTools/createManualBooking',
        ),
      ],
    ),
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

//Provider for the navigation destinations
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

//Provider that simply stores current active index StateProvider
final selectedScreenIndexProvider = StateProvider<int>((ref) => 0);

final mobileSelectedScreenIndexProvider = Provider<int>((ref) {
  final globalIndex = ref.watch(selectedScreenIndexProvider);
  final mobileScreens = ref.watch(navigationDestinationsProvider);
  if (globalIndex >= mobileScreens.length) {
    return 0;
  }
  return globalIndex;
});

//function that updates index based on route
void updateIndexBasedOnRoute(BuildContext context, WidgetRef ref) {
  final StateController<int> selectedScreenIndexProviderRef =
      ref.read(selectedScreenIndexProvider.notifier);
  final int newIndex = ref
      .watch(screensProvider)
      .indexWhere((screen) => screen.isActive(context));
  selectedScreenIndexProviderRef.state = newIndex;
}
