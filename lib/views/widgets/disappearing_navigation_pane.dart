import 'package:animated_sidebar/animated_sidebar.dart';
import 'package:dashboard/models/coach.dart';
import 'package:dashboard/providers/current_coach_provider.dart';
import 'package:dashboard/providers/navigation.dart';
import 'package:dashboard/providers/navigation/indexed_screens_provider.dart';
import 'package:dashboard/providers/navigation/selected_screen_index_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DisappearingNavigationRail extends ConsumerWidget {
  const DisappearingNavigationRail({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedScreenIndexProvider);
    final AsyncValue<Coach?> coachValue = ref.watch(currentCoachProvider);

    return coachValue.when(
      data: (Coach? coach) {
        final isAdmin = coach?.isAdmin ?? false;
        final indexedScreens = isAdmin
            ? ref.watch(indexedScreensProvider)
            : ref
                .watch(indexedScreensProvider)
                .where((element) => !element.isAdminOnly)
                .toList();

        final items = isAdmin
            ? ref.watch(adminsSideBarItemsProvider)
            : ref.watch(sideBarItemsProvider);
        return AnimatedSidebar(
          expanded: MediaQuery.of(context).size.width > 600,
          items: items,
          selectedIndex: selectedIndex,
          autoSelectedIndex:
              false, // must be false if you want to handle state external
          onItemSelected: (index) {
            ref
                .read(selectedScreenIndexProvider.notifier)
                .updateIndexBasedOnRouteName(indexedScreens[index].route);
            final screen = indexedScreens[index];
            GoRouter.of(context).go(screen.route);
          },
          itemSelectedColor:
              const Color.fromARGB(255, 10, 222, 219).withOpacity(0.35),
          frameDecoration: BoxDecoration(
            color: Colors.blue,
            gradient: const SweepGradient(
              colors: [Color(0xff1ccef2), Color(0xff004bfa)],
              stops: [0, 1],
              center: Alignment.topRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          header: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Image(image: AssetImage('assets/logo.png')),
          ),
        );
      },
      loading: () {
        final indexedScreens = ref
            .watch(indexedScreensProvider)
            .where((element) => !element.isAdminOnly)
            .toList();

        final items = ref.watch(sideBarItemsProvider);
        return AnimatedSidebar(
          expanded: MediaQuery.of(context).size.width > 600,
          items: items,
          selectedIndex: selectedIndex,
          autoSelectedIndex:
              false, // must be false if you want to handle state external
          onItemSelected: (index) {
            ref
                .read(selectedScreenIndexProvider.notifier)
                .updateIndexBasedOnRouteName(indexedScreens[index].route);
            GoRouter.of(context).go(indexedScreens[index].route);
          },
          itemSelectedColor:
              const Color.fromARGB(255, 10, 222, 219).withOpacity(0.35),
          frameDecoration: BoxDecoration(
            color: Colors.blue,
            gradient: const SweepGradient(
              colors: [Color(0xff1ccef2), Color(0xff004bfa)],
              stops: [0, 1],
              center: Alignment.topRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          header: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Image(image: AssetImage('assets/logo.png')),
          ),
        );
      },
      error: (error, stackTrace) {
        throw error;
      },
    );
  }
}
