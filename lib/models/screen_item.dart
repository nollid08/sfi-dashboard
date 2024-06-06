import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class ScreenItem {
  final String title;
  final Widget content;
  final IconData icon;
  final String route;
  final bool isDesktopOnly;
  final List<ScreenItem>? children;
  final String activeRouteIdentifier;

  ScreenItem(
    this.route, {
    required this.title,
    required this.content,
    required this.icon,
    this.isDesktopOnly = false,
    this.children,
    required this.activeRouteIdentifier,
  });

  bool isActive(BuildContext context) {
    final String currentRoute =
        GoRouter.of(context).routeInformationProvider.value.uri.path;
    if (currentRoute.contains(activeRouteIdentifier)) {
      return true;
    } else {
      return false;
    }
  }
}
