import 'package:dashboard/models/assigned_coach.dart';
import 'package:dashboard/models/coach.dart';
import 'package:dashboard/models/session.dart';
import 'package:dashboard/models/travel_info.dart';
import 'package:dashboard/providers/sessions_provider.dart';
import 'package:dashboard/views/widgets/add_new_coaches_to_all_sessions_dialog.dart';
import 'package:dashboard/views/widgets/add_new_coaches_to_single_session_dialog.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
                                      'Departing Eircode: ${travelInfo.departureLocation}',
                                    ),
                                    Text(
                                      'Returning Eircode: ${travelInfo.returnLocation}',
                                    ),
                                  ],
                                ),
                                Row(children: [
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
                                  IconButton.filled(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return EditInitialLocations(
                                            assignedCoach: assignedCoach,
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.commute),
                                  ),
                                ]),
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

class EditInitialLocations extends ConsumerWidget {
  EditInitialLocations({
    super.key,
    required this.assignedCoach,
  });

  final AssignedCoach assignedCoach;
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Edit Initial Locations'),
      content: FormBuilder(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: assignedCoach.travelInfo.departureLocation,
              decoration: const InputDecoration(labelText: 'Departure Eircode'),
              maxLength: 7,
              inputFormatters: [
                UpperCaseTextFormatter(),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid Eircode';
                }
                //length == 7
                if (value.length != 7) {
                  return 'Eircode must be 7 characters long';
                }
                //Regex Check
                if (!RegExp(r'([AC-FHKNPRTV-Y]\d{2}|D6W)[0-9AC-FHKNPRTV-Y]{4}')
                    .hasMatch(value.toUpperCase().replaceAll(' ', ''))) {
                  return 'Please enter a valid Eircode';
                }
                return null;
              },
            ),
            TextFormField(
              initialValue: assignedCoach.travelInfo.returnLocation,
              decoration: const InputDecoration(labelText: 'Return Eircode'),
              maxLength: 7,
              inputFormatters: [
                UpperCaseTextFormatter(),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid Eircode';
                }
                //length == 7
                if (value.length != 7) {
                  return 'Eircode must be 7 characters long';
                }
                //Regex Check
                if (!RegExp(r'([AC-FHKNPRTV-Y]\d{2}|D6W)[0-9AC-FHKNPRTV-Y]{4}')
                    .hasMatch(value.toUpperCase().replaceAll(' ', ''))) {
                  return 'Please enter a valid Eircode';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState?.saveAndValidate() ?? false) {
              final values = formKey.currentState!.value;
              final String departureLocation = values['departureLocation']
                  .toString()
                  .replaceAll(' ', '')
                  .toUpperCase();
              final String returnLocation = values['returnLocation']
                  .toString()
                  .replaceAll(' ', '')
                  .toUpperCase();

              print('Departure Location: $departureLocation');
              print('Return Location: $returnLocation');
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase().replaceAll(' ', ''),
      selection: newValue.selection,
    );
  }
}
