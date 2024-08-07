import 'package:dashboard/providers/navigation/screens_provider.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigation_destinations_provider.g.dart';

@riverpod
List<NavigationDestination> navigationDestinations(
    NavigationDestinationsRef ref) {
  final screens = ref.watch(screensProvider);
  return screens
      .map((screen) {
        if (!screen.isAdminOnly) {
          return NavigationDestination(
            icon: Icon(screen.icon),
            label: screen.title,
          );
        }
      })
      .whereType<NavigationDestination>()
      .toList();
}
