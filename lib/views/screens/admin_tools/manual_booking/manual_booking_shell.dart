import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManualBookingShell extends StatefulWidget {
  final Widget child;
  const ManualBookingShell(
    this.child, {
    super.key,
  });

  @override
  State<ManualBookingShell> createState() => _ManualBookingShellState();
}

class _ManualBookingShellState extends State<ManualBookingShell>
    with AutomaticKeepAliveClientMixin {
  // Override `wantKeepAlive` when using `AutomaticKeepAliveClientMixin`.
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.child,
        ),
      ),
    );
  }
}
