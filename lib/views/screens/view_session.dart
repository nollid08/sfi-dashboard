import 'package:dashboard/models/session.dart';
import 'package:dashboard/providers/sessions_provider.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';

class ViewSession extends ConsumerStatefulWidget {
  final String bookingId;
  final int sessionIndex;

  const ViewSession({
    super.key,
    required this.bookingId,
    required this.sessionIndex,
  });

  @override
  ConsumerState<ViewSession> createState() => _ViewSessionState();
}

class _ViewSessionState extends ConsumerState<ViewSession> {
  final formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Session>> sessions =
        ref.watch(sessionsProvider(bookingIds: [widget.bookingId].lock));

    if (widget.sessionIndex == -1) {
      return Text(
          'This booking does not have a session no. ${widget.sessionIndex + 1}');
    }

    return sessions.when(
      data: (List<Session> sessions) {
        final Session session = sessions[widget.sessionIndex];
        return Flexible(
          flex: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Session No. ${widget.sessionIndex + 1}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text(
                              'Session Times',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            ListTile(
                              leading: const Icon(Icons.calendar_month),
                              title: Text(
                                  'Arrival Time: ${DateFormat("hh:mm dd/MM/yy").format(session.arrivalTime)}'),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.calendar_month),
                              title: Text(
                                  'Start Time: ${DateFormat("hh:mm dd/MM/yy").format(session.startTime)}'),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.calendar_month),
                              title: Text(
                                  'End Time: ${DateFormat("hh:mm dd/MM/yy").format(session.endTime)}'),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.calendar_month),
                              title: Text(
                                  'Leave Time: ${DateFormat("hh:mm dd/MM/yy").format(session.leaveTime)}'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Text(
                                'Notes',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                session.notes ?? 'No notes for this session',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Text(
                                'Assigned Coaches',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: session.assignedCoaches.length,
                                  itemBuilder: (context, index) {
                                    final ac = session.assignedCoaches[index];
                                    return ListTile(
                                      leading: const Icon(Icons.person),
                                      title: Text(ac.coach.name),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    FilledButton.icon(
                        onPressed: () {
                          MapsLauncher.launchQuery(
                            session.client.eircode,
                          );
                        },
                        label: const Text('Take Me There!'),
                        icon: const Icon(Icons.map)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
