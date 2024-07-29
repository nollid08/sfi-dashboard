import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/session.dart';
import 'package:dashboard/providers/sessions_provider.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddBookingSession extends ConsumerWidget {
  final String bookingId;

  AddBookingSession({
    super.key,
    required this.bookingId,
  });
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Session>> sessions =
        ref.watch(sessionsProvider(bookingIds: [bookingId].lock));

    return sessions.when(
      data: (List<Session> sessions) {
        return Center(
          child: Card(
            elevation: 5,
            surfaceTintColor: Colors.blue[600],
            shadowColor: Colors.blue[900],
            child: SizedBox(
              width: 350,
              height: 500,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FormBuilder(
                  autovalidateMode: AutovalidateMode.disabled,
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Add A New Session',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: FormBuilderDateTimePicker(
                                name: 'start-date-time',
                                decoration: const InputDecoration(
                                  labelText: 'Start Date & Time',
                                  border: OutlineInputBorder(),
                                ),
                                autofocus: false,
                                autocorrect: false,
                                inputType: InputType.both,
                                validator: (DateTime? startDateTime) {
                                  final DateTime? endTime = formKey
                                      .currentState?.fields['end-time']?.value;
                                  final DateTime? endDateTime =
                                      startDateTime?.copyWith(
                                    hour: endTime?.hour,
                                    minute: endTime?.minute,
                                  );
                                  if (startDateTime != null &&
                                      endDateTime != null) {
                                    if (startDateTime.isAfter(endDateTime)) {
                                      return 'Start time must be before end time';
                                    }
                                  } else {
                                    return "All Dates must have a value";
                                  }
                                  //Validate that the selected session times will not clash with any of the other sessions
                                  for (final session in sessions) {
                                    if (session.startTime
                                            .isBefore(startDateTime) &&
                                        session.endTime.isAfter(endDateTime)) {
                                      return 'Session times clash with another session';
                                    }
                                    if (session.startTime
                                            .isAfter(startDateTime) &&
                                        session.startTime
                                            .isBefore(endDateTime)) {
                                      return 'Session times clash with another session';
                                    }
                                    if (session.endTime
                                            .isAfter(startDateTime) &&
                                        session.endTime.isBefore(endDateTime)) {
                                      return 'Session times clash with another session';
                                    }
                                    if (session.startTime
                                            .isAtSameMomentAs(startDateTime) ||
                                        session.endTime
                                            .isAtSameMomentAs(endDateTime)) {
                                      return 'Session times clash with another session';
                                    }
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: FormBuilderDateTimePicker(
                                name: 'end-time',
                                decoration: const InputDecoration(
                                  labelText: 'End Time',
                                  border: OutlineInputBorder(),
                                ),
                                inputType: InputType.time,
                                validator: (DateTime? newEndTime) {
                                  final DateTime? startDateTime = formKey
                                      .currentState
                                      ?.fields['start-date-time']
                                      ?.value;
                                  final DateTime? endDateTime =
                                      startDateTime?.copyWith(
                                    hour: newEndTime?.hour,
                                    minute: newEndTime?.minute,
                                  );
                                  if (startDateTime != null &&
                                      endDateTime != null) {
                                    //Validate Selected End Time is after Start Time
                                    if (startDateTime.isAfter(endDateTime)) {
                                      return 'End time must be before departure time';
                                    }
                                    //Validate that the selected session times will not clash with any of the other sessions
                                    for (final session in sessions) {
                                      if (session.startTime
                                              .isBefore(startDateTime) &&
                                          session.endTime
                                              .isAfter(endDateTime)) {
                                        return 'Session times clash with another session';
                                      }
                                      if (session.startTime
                                              .isAfter(startDateTime) &&
                                          session.startTime
                                              .isBefore(endDateTime)) {
                                        return 'Session times clash with another session';
                                      }
                                      if (session.endTime
                                              .isAfter(startDateTime) &&
                                          session.endTime
                                              .isBefore(endDateTime)) {
                                        return 'Session times clash with another session';
                                      }
                                      if (session.startTime.isAtSameMomentAs(
                                              startDateTime) ||
                                          session.endTime
                                              .isAtSameMomentAs(endDateTime)) {
                                        return 'Session times clash with another session';
                                      }
                                    }
                                  } else {
                                    return "All Dates must have a value";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FilledButton(
                          onPressed: () async {
                            if (formKey.currentState?.saveAndValidate() ??
                                false) {
                              final Map<String, dynamic> formValues =
                                  formKey.currentState!.value;
                              final DateTime startDateTime =
                                  formValues['start-date-time'];
                              final DateTime endTime = formValues['end-time'];
                              final DateTime endDateTime =
                                  startDateTime.copyWith(
                                hour: endTime.hour,
                                minute: endTime.minute,
                              );
                              final DateTime arrivalTime =
                                  startDateTime.subtract(
                                const Duration(minutes: 30),
                              );
                              final DateTime leaveTime = endDateTime.add(
                                const Duration(minutes: 30),
                              );
                              final db = FirebaseFirestore.instance;
                              final id = db.collection('sessions').doc().id;
                              final newSession = sessions.last.copyWith(
                                assignedCoaches: [],
                                id: id,
                                startTime: startDateTime,
                                endTime: endDateTime,
                                arrivalTime: arrivalTime,
                                leaveTime: leaveTime,
                                notes: null,
                              );
                              //Find the index of the new session when the sessions array is sorted by starttime, oldes first
                              final List<Session> allSessions = [
                                ...sessions,
                                newSession
                              ];
                              allSessions.sort(
                                  (a, b) => a.startTime.compareTo(b.startTime));
                              final int newSessionIndex =
                                  allSessions.indexOf(newSession);

                              await ref
                                  .read(sessionsProvider(
                                          bookingIds: [bookingId].lock)
                                      .notifier)
                                  .addSession(newSession);
                              if (context.mounted) {
                                context.go(
                                    '/adminTools/manageBookings/$bookingId/session/$newSessionIndex');
                              }
                            }
                          },
                          child: const Text('Add Session'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
