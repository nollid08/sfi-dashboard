import 'package:dashboard/models/screen_item.dart';
import 'package:dashboard/providers/navigation/indexed_screens_provider.dart';
import 'package:dashboard/providers/navigation/selected_screen_index_provider.dart';
import 'package:dashboard/views/widgets/disappearing_bottom_navigation.dart';
import 'package:dashboard/views/widgets/disappearing_navigation_pane.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationShell extends ConsumerStatefulWidget {
  const NavigationShell({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends ConsumerState<NavigationShell> {
  bool wideScreen = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    wideScreen = width > 600;
  }

  @override
  Widget build(BuildContext context) {
    int currentlySelectedScreenIndex = ref.watch(selectedScreenIndexProvider);
    ScreenItem currentlySelectedScreen =
        ref.watch(indexedScreensProvider)[currentlySelectedScreenIndex];

    return Scaffold(
      body: wideScreen
          ? Row(
              children: [
                const DisappearingNavigationRail(),
                Expanded(
                  child: widget.child,
                ),
              ],
            )
          : widget.child,
      bottomNavigationBar:
          wideScreen ? null : const DisappearingBottomNavigationBar(),
    );
  }
}
