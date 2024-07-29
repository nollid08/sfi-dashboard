import 'package:animated_sidebar/animated_sidebar.dart';
import 'package:dashboard/models/screen_item.dart';
import 'package:dashboard/providers/navigation/navigation_destinations_provider.dart';
import 'package:dashboard/providers/navigation/screens_provider.dart';
import 'package:dashboard/providers/navigation/selected_screen_index_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sideBarItemsProvider = Provider<List<SidebarItem>>((ref) {
  final screens = ref.read(screensProvider);
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
