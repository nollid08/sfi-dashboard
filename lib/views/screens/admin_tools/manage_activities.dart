import 'package:dashboard/models/activity.dart';
import 'package:dashboard/providers/activity_provider.dart';
import 'package:dashboard/views/dialogs/add_activity_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Activities extends ConsumerWidget {
  const Activities({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Retrieve the list of activities from the provider
    final AsyncValue<List<Activity>> activities = ref.watch(activitiesProvider);

    return Scaffold(
        body: activities.when(
          data: (activityList) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: ListView.builder(
                  itemCount: activityList.length,
                  itemBuilder: (context, index) {
                    final Activity activity = activityList[index];
                    return ListTile(
                      leading: Icon(activity.icon, color: activity.color),
                      title: Text(activity.name),
                    );
                  },
                ),
              ),
            );
          },
          loading: () => const Center(
            child: SizedBox.square(
              dimension: 100,
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stackTrace) => Text('Error: $error'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            //Show a dialog to add a new activity
            showDialog(
              context: context,
              builder: (context) {
                return const AddActivityDialog();
              },
            );
          },
          label: const Text('Add Activity'),
          icon: const Icon(Icons.add),
        ));
  }
}
