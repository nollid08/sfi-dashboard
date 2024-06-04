import 'package:dashboard/providers/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DisappearingBottomNavigationBar extends ConsumerWidget {
  const DisappearingBottomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screens = ref.watch(screensProvider);
    final selectedIndex = ref.watch(selectedScreenIndexProvider);
    return NavigationBar(
      elevation: 0,
      backgroundColor: Colors.white,
      destinations: screens.map((screen) {
        return NavigationDestination(
          icon: Icon(screen.icon),
          label: screen.title,
        );
      }).toList(),
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        ref.read(selectedScreenIndexProvider.notifier).state = index;
        GoRouter.of(context).go(screens[index].route);
      },
    );
  }
}
