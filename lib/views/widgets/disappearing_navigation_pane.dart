import 'package:animated_sidebar/animated_sidebar.dart';
import 'package:dashboard/models/screen_item.dart';
import 'package:dashboard/providers/navigation.dart';
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
    final indexedScreens = ref.watch(indexedScreensProvider);

    final items = ref.watch(sideBarItemsProvider);
    return AnimatedSidebar(
      expanded: MediaQuery.of(context).size.width > 600,
      items: items,
      selectedIndex: selectedIndex,
      autoSelectedIndex:
          false, // must be false if you want to handle state external
      onItemSelected: (index) {
        ref.read(selectedScreenIndexProvider.notifier).state = index;
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
  }
}
