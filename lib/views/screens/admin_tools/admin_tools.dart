import 'package:dashboard/providers/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdminTools extends ConsumerWidget {
  const AdminTools({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
          child: SizedBox(
        height: 400,
        child: Row(
          children: [
            Flexible(
              child: Card(
                surfaceTintColor: Colors.blue,
                child: SizedBox(
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Title
                        const Text('Manage Coaches',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        const Text(
                            'Add, edit, or delete coaches profiles from the system. Continue with Caution'),
                        Expanded(
                          child: Container(),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context.go('/adminTools/manageCoaches');
                              },
                              child: const Text('Manage Coaches'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Card(
                surfaceTintColor: Colors.blue,
                child: SizedBox(
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Title
                        const Text('Manual Booking',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        const Text(
                            'This tool allows you to manually book a session for a client. Camp creation is seperate from this. '),
                        Expanded(
                          child: Container(),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context.go('/adminTools/createManualBooking');
                              },
                              child: const Text('Manual Booking'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Card(
                surfaceTintColor: Colors.blue,
                child: SizedBox(
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Title
                        const Text('Manual Booking',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        const Text(
                            'This tool allows you to manually book a session for a client. Camp creation is seperate from this. '),
                        Expanded(
                          child: Container(),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context.go('/adminTools/createManualBooking');
                              },
                              child: const Text('Manual Booking'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
