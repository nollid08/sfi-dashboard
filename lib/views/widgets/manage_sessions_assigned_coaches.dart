import 'package:dashboard/models/assigned_coach.dart';
import 'package:dashboard/models/coach.dart';
import 'package:dashboard/models/session.dart';
import 'package:dashboard/models/travel_info.dart';
import 'package:dashboard/providers/sessions_provider.dart';
import 'package:dashboard/views/widgets/add_new_coaches_to_all_sessions_dialog.dart';
import 'package:dashboard/views/widgets/add_new_coaches_to_single_session_dialog.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageSessionsAssignedCoaches extends ConsumerStatefulWidget {
  const ManageSessionsAssignedCoaches({
    super.key,
    required this.session,
  });

  final Session session;

  @override
  ConsumerState<ManageSessionsAssignedCoaches> createState() =>
      _ManageSessionsAssignedCoachesState();
}

class _ManageSessionsAssignedCoachesState
    extends ConsumerState<ManageSessionsAssignedCoaches> {
  final List<AssignedCoach> selectedCoaches = [];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        surfaceTintColor: Colors.blue[600],
        shadowColor: Colors.blue[900],
        elevation: 3,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'Assigned Coaches',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final AssignedCoach assignedCoach =
                      widget.session.assignedCoaches[index];
                  final Coach coach = assignedCoach.coach;
                  final TravelInfo travelInfo = assignedCoach.travelInfo;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedCoaches.contains(assignedCoach)) {
                          selectedCoaches.remove(assignedCoach);
                        } else {
                          selectedCoaches.add(assignedCoach);
                        }
                      });
                    },
                    child: Card(
                      color: selectedCoaches.contains(assignedCoach)
                          ? Colors.blue[50]
                          : const Color.fromARGB(255, 236, 239, 241),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: selectedCoaches.contains(assignedCoach)
                                ? Colors.blue
                                : Colors.grey[400]!,
                            width: 2.0),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      borderOnForeground: true,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      coach.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      'Base Eircode: ${coach.baseEircode}',
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Distance: ${(travelInfo.distance / 1000).round()} km',
                                    ),
                                    Text(
                                      'Travel Time: ${travelInfo.duration.inMinutes} minutes',
                                    ),
                                    Text(
                                        'Leave Time: ${widget.session.arrivalTime.subtract(travelInfo.duration)}'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: widget.session.assignedCoaches.length,
              ),
            ),
            OverflowBar(
              spacing: 8,
              children: [
                FilledButton(
                  onPressed: selectedCoaches.isNotEmpty
                      ? () {
                          final sessionsNotifier = ref.read(sessionsProvider(
                            bookingIds: [
                              widget.session.bookingId,
                            ].lock,
                          ).notifier);

                          sessionsNotifier.removeCoachesFromSession(
                            session: widget.session,
                            coaches:
                                selectedCoaches.map((e) => e.coach).toList(),
                          );
                        }
                      : null,
                  child: Text(
                    'Remove ${selectedCoaches.length} ${selectedCoaches.length == 1 ? 'Coach' : 'Coaches'} from this Session',
                  ),
                ),
                FilledButton(
                  onPressed: selectedCoaches.isNotEmpty
                      ? () async {
                          final sessionsNotifier = ref.read(sessionsProvider(
                            bookingIds: [
                              widget.session.bookingId,
                            ].lock,
                          ).notifier);

                          await sessionsNotifier
                              .removeCoachesFromAllSessionsInBooking(
                            bookingId: widget.session.bookingId,
                            coachesToRemove:
                                selectedCoaches.map((e) => e.coach).toList(),
                            assignedCoaches: widget.session.assignedCoaches,
                          );
                        }
                      : null,
                  child: Text(
                    'Remove ${selectedCoaches.length} ${selectedCoaches.length == 1 ? 'Coach' : 'Coaches'} from all Sessions',
                  ),
                ),
                FilledButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AddNewCoachesToAllSessionsDialog(
                          alreadyAssignedCoaches:
                              widget.session.assignedCoaches,
                          session: widget.session,
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Assign New Coach(es) To All Sessions',
                  ),
                ),
                FilledButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AddNewCoachesToSingleSessionsDialog(
                          alreadyAssignedCoaches:
                              widget.session.assignedCoaches,
                          session: widget.session,
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Assign New Coach(es) To This Session',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
