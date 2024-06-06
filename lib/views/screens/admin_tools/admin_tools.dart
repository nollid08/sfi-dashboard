import 'package:dashboard/models/screen_item.dart';
import 'package:dashboard/providers/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdminTools extends ConsumerWidget {
  const AdminTools({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Grid of 4 cards - each with a title, subtitle, and button to navigate to the respective screen
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
          child: SizedBox(
        height: 400,
        child: Row(
          children: [
            Card(
              surfaceTintColor: Colors.blue,
              child: SizedBox(
                width: 400,
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
                              navigateToScreenByRouteName(
                                  context, ref, '/adminTools/manageCoaches');
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
          ],
        ),
      )),
    );
  }
}
