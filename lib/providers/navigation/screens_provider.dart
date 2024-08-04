import 'package:dashboard/models/screen_item.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'screens_provider.g.dart';

@riverpod
List<ScreenItem> screens(ScreensRef ref) {
  return [
    ScreenItem(
      '/myCalendar',
      title: 'My Calendar',
      icon: Icons.calendar_today,
      activeRouteIdentifier: '/myCalendar',
    ),
    ScreenItem(
      '/myFutureBookings',
      title: 'Future Bookings',
      icon: Icons.update,
      activeRouteIdentifier: '/myFutureBookings',
    ),
    ScreenItem(
      '/myPastBookings',
      title: 'Past Bookings',
      icon: Icons.history,
      activeRouteIdentifier: '/myPastBookings',
    ),
    ScreenItem(
      '/myLeave',
      title: 'My Leave',
      icon: Icons.beach_access,
      activeRouteIdentifier: '/myProfile',
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
        ScreenItem(
          '/adminTools/manageBookings',
          title: 'Manage Bookings',
          icon: Icons.book,
          activeRouteIdentifier: '/adminTools/manageBookings',
        ),
        ScreenItem(
          '/adminTools/manageLeaveRequests',
          title: 'Manage Leave Requests',
          icon: Icons.beach_access,
          activeRouteIdentifier: '/adminTools/manageLeaveRequests',
        ),
      ],
    ),
  ];
}
