import 'package:dashboard/models/session.dart';
import 'package:dashboard/providers/sessions_provider.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageSessionTimes extends ConsumerStatefulWidget {
  const ManageSessionTimes({super.key, required this.session});

  final Session session;

  @override
  ConsumerState<ManageSessionTimes> createState() => _ManageSessionTimesState();
}

class _ManageSessionTimesState extends ConsumerState<ManageSessionTimes> {
  bool datesHaveChanged = false;
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    return Card(
      surfaceTintColor: Colors.blue[600],
      shadowColor: Colors.blue[900],
      elevation: 3,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Time & Dates',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FormBuilder(
              onChanged: () {
                if (!formKey.currentState!.saveAndValidate()) {
                  return;
                }
                final DateTime arrivalTime =
                    formKey.currentState?.fields['arrival-time']?.value;
                final DateTime startTime =
                    formKey.currentState?.fields['start-time']?.value;
                final DateTime endTime =
                    formKey.currentState?.fields['end-time']?.value;
                final DateTime leaveTime =
                    formKey.currentState?.fields['leave-time']?.value;
                if (arrivalTime != widget.session.arrivalTime ||
                    startTime != widget.session.startTime ||
                    endTime != widget.session.endTime ||
                    leaveTime != widget.session.leaveTime) {
                  setState(() {
                    datesHaveChanged = true;
                  });
                } else {
                  setState(() {
                    datesHaveChanged = false;
                  });
                }
              },
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FormBuilderDateTimePicker(
                      name: 'arrival-time',
                      decoration: const InputDecoration(
                        labelText: 'Arrival Time',
                        border: OutlineInputBorder(),
                      ),
                      autofocus: false,
                      autocorrect: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (DateTime? newArrivalTime) {
                        final DateTime? startTime =
                            formKey.currentState?.fields['start-time']?.value;
                        if (newArrivalTime != null && startTime != null) {
                          if (newArrivalTime.isAfter(startTime)) {
                            return 'Arrival time must be before start time';
                          }
                        } else {
                          return "All Dates must have a value";
                        }
                        return null;
                      },
                      initialValue: widget.session.arrivalTime,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: FormBuilderDateTimePicker(
                        name: 'start-time',
                        decoration: const InputDecoration(
                          labelText: 'Start Time',
                          border: OutlineInputBorder(),
                        ),
                        autofocus: false,
                        autocorrect: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (DateTime? newStartTime) {
                          final DateTime? arrivalTime = formKey
                              .currentState?.fields['arrival-time']?.value;
                          final DateTime? endTime =
                              formKey.currentState?.fields['end-time']?.value;
                          if (arrivalTime != null &&
                              newStartTime != null &&
                              endTime != null) {
                            if (newStartTime.isAfter(endTime)) {
                              return 'Start time must be before end time';
                            }
                          } else {
                            return "All Dates must have a value";
                          }
                          return null;
                        },
                        initialValue: widget.session.startTime,
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
                        autofocus: false,
                        autocorrect: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (DateTime? newEndTime) {
                          final DateTime? startTime =
                              formKey.currentState?.fields['start-time']?.value;
                          final DateTime? leaveTime =
                              formKey.currentState?.fields['leave-time']?.value;
                          if (startTime != null &&
                              newEndTime != null &&
                              leaveTime != null) {
                            if (newEndTime.isAfter(leaveTime)) {
                              return 'End time must be before departure time';
                            }
                          } else {
                            return "All Dates must have a value";
                          }
                          return null;
                        },
                        initialValue: widget.session.endTime,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: FormBuilderDateTimePicker(
                        name: 'leave-time',
                        decoration: const InputDecoration(
                          labelText: 'Leave Time',
                          border: OutlineInputBorder(),
                        ),
                        autofocus: false,
                        autocorrect: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (DateTime? newLeaveTime) {
                          final DateTime? endTime =
                              formKey.currentState?.fields['end-time']?.value;
                          if (endTime != null && newLeaveTime != null) {
                            if (newLeaveTime.isBefore(endTime)) {
                              return 'Leave time must be after end time';
                            }
                          } else {
                            return "All Dates must have a value";
                          }
                          return null;
                        },
                        initialValue: widget.session.leaveTime,
                      ),
                    ),
                  ),
                  Wrap(
                    alignment: WrapAlignment.end,
                    direction: Axis.horizontal,
                    children: [
                      FilledButton(
                        onPressed: datesHaveChanged
                            ? () async {
                                if (formKey.currentState?.saveAndValidate() ??
                                    false) {
                                  final Map<String, dynamic> formValues =
                                      formKey.currentState!.value;
                                  final DateTime arrivalTime =
                                      formValues['arrival-time'];
                                  final DateTime startTime =
                                      formValues['start-time'];
                                  final DateTime endTime =
                                      formValues['end-time'];
                                  final DateTime leaveTime =
                                      formValues['leave-time'];
                                  // context.loaderOverlay.show();
                                  await ref
                                      .read(sessionsProvider(
                                              bookingIds: [
                                        widget.session.bookingId
                                      ].lock)
                                          .notifier)
                                      .updateAllSessionTimes(
                                        bookingId: widget.session.bookingId,
                                        sessionId: widget.session.id,
                                        newArrivalTime: arrivalTime,
                                        newStartTime: startTime,
                                        newEndTime: endTime,
                                        newLeaveTime: leaveTime,
                                      );
                                  // if (context.mounted) {
                                  //   context.loaderOverlay.hide();
                                  // }
                                }
                              }
                            : null,
                        child: const Text(
                            'Update Times (Not Dates) For all Sessions'),
                      ),
                      const SizedBox.square(
                        dimension: 4,
                      ),
                      FilledButton(
                        onPressed: datesHaveChanged
                            ? () async {
                                if (formKey.currentState?.saveAndValidate() ??
                                    false) {
                                  final Map<String, dynamic> formValues =
                                      formKey.currentState!.value;
                                  final DateTime arrivalTime =
                                      formValues['arrival-time'];
                                  final DateTime startTime =
                                      formValues['start-time'];
                                  final DateTime endTime =
                                      formValues['end-time'];
                                  final DateTime leaveTime =
                                      formValues['leave-time'];
                                  // context.loaderOverlay.show();
                                  await ref
                                      .read(sessionsProvider(
                                              bookingIds: [
                                        widget.session.bookingId
                                      ].lock)
                                          .notifier)
                                      .updateSessionDateTimes(
                                        sessionId: widget.session.id,
                                        newArrivalTime: arrivalTime,
                                        newStartTime: startTime,
                                        newEndTime: endTime,
                                        newLeaveTime: leaveTime,
                                      );
                                  // context.loaderOverlay.hide();
                                }
                              }
                            : null,
                        child: const Text(
                            'Update Date and Time For This Session ONLY'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
