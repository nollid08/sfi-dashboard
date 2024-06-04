import 'package:dashboard/models/screen_item.dart';
import 'package:dashboard/views/screens/my_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  ];
});

// Another provider to store the selected screen index
final selectedScreenIndexProvider = StateProvider<int>((ref) => 0);
