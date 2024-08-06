import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class ScreenItem {
  final String title;
  final IconData icon;
  final String route;
  final bool isDesktopOnly;
  final List<ScreenItem>? children;
  final String activeRouteIdentifier;

  ScreenItem(
    this.route, {
    required this.title,
    required this.icon,
    this.isDesktopOnly = false,
    this.children,
    required this.activeRouteIdentifier,
  });

  bool isActive(String currentRoute) {
    if (currentRoute.contains(route)) {
      return true;
    } else {
      return false;
    }
  }
}
