import 'package:dashboard/providers/is_wide_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Swrap extends ConsumerWidget {
  const Swrap({super.key, required this.child, this.padding = 0.0});
  final double padding;
  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isWideScreen = ref.watch(
      isWideScreenProvider(
        MediaQuery.of(context),
      ),
    );

    if (isWideScreen) {
      return Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: child,
        ),
      );
    } else {
      return child;
    }
  }
}
