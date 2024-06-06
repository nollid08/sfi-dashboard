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
    int selectedIndex = ref.watch(mobileSelectedScreenIndexProvider);
    final navigationDestinations = ref.watch(navigationDestinationsProvider);
    return NavigationBar(
      elevation: 0,
      backgroundColor: Colors.white,
      destinations: navigationDestinations,
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        //NOTE: Since some items are desktop only, we need to map the index to the actual index in the screens list
        final int navIndex = screens.indexWhere(
            (element) => element.title == navigationDestinations[index].label);
        //Now we can route to the nav Index, but must set selected index to the actual index
        ref.read(selectedScreenIndexProvider.notifier).state = index;
        GoRouter.of(context).go(screens[navIndex].route);
      },
    );
  }
}
