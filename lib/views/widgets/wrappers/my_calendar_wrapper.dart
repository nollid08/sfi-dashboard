import 'package:dashboard/providers/is_wide_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyCalendarWrapper extends ConsumerWidget {
  const MyCalendarWrapper(
      {super.key,
      required this.calendar,
      required this.onAnnualLeaveRequested});

  final Widget calendar;
  final Function() onAnnualLeaveRequested;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isWideScreen = ref.watch(
      isWideScreenProvider(
        MediaQuery.of(context),
      ),
    );
    //Desktop
    if (isWideScreen) {
      return Card(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: calendar,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton.icon(
                    onPressed: onAnnualLeaveRequested,
                    label: const Text('Request Annual Leave'),
                    icon: const Icon(Icons.beach_access),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      //Mobile
      return Scaffold(
        body: calendar,
        floatingActionButton: FloatingActionButton(
          onPressed: onAnnualLeaveRequested,
          child: const Icon(Icons.beach_access),
        ),
      );
    }
  }
}
