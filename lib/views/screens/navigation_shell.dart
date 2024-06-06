import 'package:dashboard/views/widgets/disappearing_bottom_navigation.dart';
import 'package:dashboard/views/widgets/disappearing_navigation_pane.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationShell extends StatefulWidget {
  const NavigationShell({super.key, required this.child});

  final Widget child;

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  bool wideScreen = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    wideScreen = width > 600;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          if (wideScreen) const DisappearingNavigationRail(),
          Expanded(
            child: widget.child,
          ),
        ],
      ),
      bottomNavigationBar:
          !wideScreen ? null : const DisappearingBottomNavigationBar(),
    );
  }
}
