import 'package:flutter/widgets.dart';

class ScreenItem {
  final String title;
  final Widget content;
  final IconData icon;
  final String route;
  final bool isDesktopOnly;
  final List<ScreenItem>? children;

  ScreenItem(
    this.route, {
    required this.title,
    required this.content,
    required this.icon,
    this.isDesktopOnly = false,
    this.children,
  });
}
