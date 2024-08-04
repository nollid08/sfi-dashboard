import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/leave.dart';
import 'package:dashboard/models/session.dart';
import 'package:dashboard/providers/future_sessions_and_leaves.dart';
import 'package:dashboard/providers/future_sessions_provider.dart';
import 'package:dashboard/providers/leaves_provider.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class RequestAnnualLeaveDialog extends ConsumerWidget {
  RequestAnnualLeaveDialog({
    super.key,
    required this.coachUid,
  });

  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final String coachUid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Map<String, List>> coachesFutureSessions =
        ref.watch(futureSessionsAndLeavesProvider(coachUid));
    return AlertDialog(
      title: const Text('Request Annual Leave'),
      content: FormBuilder(
        key: formKey,
        child: coachesFutureSessions.when(
          data: (Map<String, List> sessionsandLeaves) {
            final List<Session> sessions =
                sessionsandLeaves['sessions']! as List<Session>;
            final List<Leave> leaves =
                sessionsandLeaves['leaves']! as List<Leave>;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormBuilderDateTimePicker(
                  name: 'start_date_time',
                  inputType: InputType.both,
                  format: DateFormat('HH:mm dd/MM/yy'),
                  decoration: const InputDecoration(
                    labelText: 'Start Date',
                    border: OutlineInputBorder(),
                  ),
                  initialDate: DateTime.now().add(const Duration(days: 7)),
                  firstDate: DateTime.now().add(const Duration(days: 7)),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 10),
                FormBuilderDateTimePicker(
                  name: 'end_date_time',
                  inputType: InputType.both,
                  format: DateFormat('HH:mm dd/MM/yy'),
                  decoration: const InputDecoration(
                    labelText: 'End Date',
                    border: OutlineInputBorder(),
                  ),
                  initialDate: DateTime.now().add(const Duration(days: 14)),
                  firstDate: DateTime.now().add(const Duration(days: 7)),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    (DateTime? endTime) {
                      final DateTime? startTime =
                          formKey.currentState!.value['start_date_time'];
                      if (startTime != null && endTime != null) {
                        if (endTime.isBefore(startTime)) {
                          return 'End date must be after start date';
                        }

                        for (final Session session in sessions) {
                          if (session.startTime.isBefore(startTime) &&
                                  session.endTime.isAfter(endTime) ||
                              session.startTime.isAfter(startTime) &&
                                  session.startTime.isBefore(endTime) ||
                              session.endTime.isAfter(startTime) &&
                                  session.endTime.isBefore(endTime) ||
                              session.startTime.isAtSameMomentAs(startTime) ||
                              session.endTime.isAtSameMomentAs(endTime) ||
                              session.endTime.isAtSameMomentAs(startTime) ||
                              session.startTime.isAtSameMomentAs(endTime)) {
                            return 'Booking Clash! Contact An Admin';
                          }
                        }
                        for (final Leave leave in leaves) {
                          if (leave.startDate.isBefore(startTime) &&
                                  leave.endDate.isAfter(endTime) ||
                              leave.startDate.isAfter(startTime) &&
                                  leave.startDate.isBefore(endTime) ||
                              leave.endDate.isAfter(startTime) &&
                                  leave.endDate.isBefore(endTime) ||
                              leave.startDate.isAtSameMomentAs(startTime) ||
                              leave.endDate.isAtSameMomentAs(endTime) ||
                              leave.endDate.isAtSameMomentAs(startTime) ||
                              leave.startDate.isAtSameMomentAs(endTime)) {
                            return 'Leave Already Booked';
                          }
                        }
                      }

                      return null;
                    },
                  ]),
                ),
              ],
            );
          },
          loading: () => const SizedBox.square(
            dimension: 50,
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) {
            return Text('Error: $error');
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            if (formKey.currentState!.saveAndValidate()) {
              final DateTime startDate =
                  formKey.currentState!.value['start_date_time'];
              final DateTime endDate =
                  formKey.currentState!.value['end_date_time'];
              final leave = Leave(
                id: FirebaseFirestore.instance.collection('leaves').doc().id,
                startDate: startDate,
                coachUid: coachUid,
                endDate: endDate,
              );
              await ref
                  .read(leavesProvider(<String>[].lock).notifier)
                  .addLeave(leave);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            }
          },
          child: const Text('Request Annual Leave '),
        ),
      ],
    );
  }
}
