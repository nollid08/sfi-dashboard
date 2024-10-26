import 'package:dashboard/providers/navigation/navigation_destinations_provider.dart';
import 'package:dashboard/providers/navigation/screens_provider.dart';
import 'package:dashboard/providers/navigation/selected_screen_index_provider.dart';
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
    int selectedIndex = ref.watch(selectedScreenIndexProvider);
    final navigationDestinations = ref.watch(navigationDestinationsProvider);
    return NavigationBar(
      elevation: 0,
      destinations: navigationDestinations,
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        ref.read(selectedScreenIndexProvider.notifier).updateIndex(index);
        context.go(screens[index].route);
      },
    );
  }
}
