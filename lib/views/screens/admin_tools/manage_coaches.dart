import 'package:dashboard/models/activity.dart';
import 'package:dashboard/models/coach.dart';
import 'package:dashboard/providers/activity_provider.dart';
import 'package:dashboard/providers/coaches_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageCoachesScreen extends ConsumerStatefulWidget {
  const ManageCoachesScreen({super.key});

  @override
  ConsumerState<ManageCoachesScreen> createState() =>
      _ManageCoachesScreenState();
}

class _ManageCoachesScreenState extends ConsumerState<ManageCoachesScreen> {
  int? selectedCoachindex;
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Coach>> coaches = ref.watch(coachesProvider);
    final AsyncValue<List<Activity>> activities = ref.watch(activitiesProvider);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: coaches.when(
          data: (List<Coach> coaches) {
            return Row(
              children: [
                Flexible(
                  child: ListView.builder(
                    itemCount: coaches.length,
                    itemBuilder: (context, index) {
                      final Coach coach = coaches[index];
                      return ListTile(
                        title: Text(coach.name),
                        subtitle: Text(coach.baseEircode ?? 'No Base Eircode'),
                        tileColor: selectedCoachindex == index
                            ? Colors.blue.withOpacity(0.4)
                            : null,
                        onTap: () {
                          setState(() {
                            selectedCoachindex = index;
                          });
                        },
                      );
                    },
                  ),
                ),
                const VerticalDivider(),
                if (selectedCoachindex != null)
                  Flexible(
                    child: Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(coaches[selectedCoachindex!].name[0]),
                          ),
                          Text(coaches[selectedCoachindex!].name),
                          if (coaches[selectedCoachindex!].baseEircode !=
                              null) ...[
                            Text(coaches[selectedCoachindex!].baseEircode!),
                            Text(
                              'Activities Covered  -${coaches[selectedCoachindex!].activitiesCovered}',
                            ),
                            activities.when(
                              data: (List<Activity> activities) {
                                return Column(
                                  children: activities
                                      .map(
                                        (activity) => CheckboxListTile(
                                          title: Text(activity.name),
                                          value: coaches[selectedCoachindex!]
                                              .activitiesCovered
                                              .contains(activity.id),
                                          onChanged: (bool? value) {
                                            ref
                                                .read(coachesProvider.notifier)
                                                .toggleActivity(
                                                  coaches[selectedCoachindex!]
                                                      .uid,
                                                  activity.id,
                                                );
                                          },
                                        ),
                                      )
                                      .toList(),
                                );
                              },
                              loading: () => const SizedBox.square(
                                child: CircularProgressIndicator(),
                              ),
                              error: (error, stackTrace) => throw error,
                            ),
                          ],
                        ],
                      ),
                    ),
                  )
              ],
            );
          },
          loading: () => const SizedBox.square(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => throw error,
        ),
      ),
    );
  }
}
