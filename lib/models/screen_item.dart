import 'package:flutter/widgets.dart';

class ScreenItem {
  final String title;
  final Widget content;
  final IconData icon;
  final String route;

  ScreenItem(
    this.route, {
    required this.title,
    required this.content,
    required this.icon,
  });
}
