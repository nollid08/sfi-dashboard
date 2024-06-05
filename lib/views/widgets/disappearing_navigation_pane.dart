import 'package:animated_sidebar/animated_sidebar.dart';
import 'package:dashboard/models/screen_item.dart';
import 'package:dashboard/providers/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sidebarx/sidebarx.dart';

class DisappearingNavigationRail extends ConsumerWidget {
  const DisappearingNavigationRail({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screens = ref.watch(screensProvider);
    final selectedIndex = ref.watch(selectedScreenIndexProvider);
    // return SidebarX(
    //   controller: SidebarXController(selectedIndex: selectedIndex),
    //   theme: SidebarXTheme(
    //     margin: const EdgeInsets.all(10),
    //     decoration: BoxDecoration(
    //       color: Colors.blue,
    //       borderRadius: BorderRadius.circular(20),
    //     ),
    //     textStyle: const TextStyle(color: Colors.white),
    //     selectedTextStyle: const TextStyle(color: Colors.white),
    //     itemTextPadding: const EdgeInsets.only(left: 30),
    //     selectedItemTextPadding: const EdgeInsets.only(left: 30),
    //     itemDecoration: BoxDecoration(
    //       border: Border.all(color: Colors.blue),
    //     ),
    //     selectedItemDecoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(10),
    //       border: Border.all(
    //         color: Colors.yellow.withOpacity(0.37),
    //       ),
    //       gradient: const LinearGradient(
    //         colors: [Colors.blueAccent, Colors.blue],
    //       ),
    //       boxShadow: [
    //         BoxShadow(
    //           color: Colors.black.withOpacity(0.28),
    //           blurRadius: 30,
    //         )
    //       ],
    //     ),
    //     iconTheme: const IconThemeData(
    //       color: Colors.white,
    //       size: 20,
    //     ),
    //   ),
    //   extendedTheme: const SidebarXTheme(
    //     width: 200,
    //     decoration: BoxDecoration(
    //       color: Colors.blue,
    //     ),
    //     margin: EdgeInsets.only(right: 10),
    //   ),
    //   headerBuilder: (context, extended) {
    //     return const SizedBox(
    //       height: 100,
    //       child: Padding(
    //         padding: EdgeInsets.all(16.0),
    //         child: FlutterLogo(),
    //       ),
    //     );
    //   },
    //   items: screens.map((ScreenItem screenItem) {
    //     return SidebarXItem(
    //       label: screenItem.title,
    //       icon: screenItem.icon,
    //       onTap: () {
    //         ref.read(selectedScreenIndexProvider.notifier).state = screens
    //             .indexWhere((screen) => screen.route == screenItem.route);
    //         GoRouter.of(context).go(screenItem.route);
    //       },
    //     );
    //   }).toList(),
    // );

    final items = screens.map((ScreenItem screenItem) {
      return SidebarItem(
        text: screenItem.title,
        icon: screenItem.icon,
      );
    }).toList();
    return AnimatedSidebar(
      expanded: MediaQuery.of(context).size.width > 600,
      items: items,
      selectedIndex: selectedIndex,
      autoSelectedIndex:
          false, // must be false if you want to handle state external
      onItemSelected: (index) {
        ref.read(selectedScreenIndexProvider.notifier).state = index;
        GoRouter.of(context).go(screens[index].route);
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
