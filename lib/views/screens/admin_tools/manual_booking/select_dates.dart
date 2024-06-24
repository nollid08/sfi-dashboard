import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/activity.dart';
import 'package:dashboard/models/booking.dart';
import 'package:dashboard/models/client.dart';
import 'package:dashboard/views/widgets/form_fields/number_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rrule/rrule.dart';

class SelectDatesScreen extends StatefulWidget {
  final Activity selectedActivity;
  final Client selectedClient;
  const SelectDatesScreen({
    super.key,
    required this.selectedActivity,
    required this.selectedClient,
  });

  @override
  State<SelectDatesScreen> createState() => _SelectDatesScreenState();
}

class _SelectDatesScreenState extends State<SelectDatesScreen> {
  bool isBookingRecurring = false;
  bool recursWeekly = true;
  ByWeekDayEntry baseDayForWeekly = ByWeekDayEntry(DateTime.now().weekday);
  final formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormBuilder(
          key: formKey,
          child: Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      FormBuilderDateTimePicker(
                        decoration: const InputDecoration(
                            labelText: 'Select Initial Date'),
                        name: 'initialDate',
                        inputType: InputType.date,
                        initialValue: DateTime.now(),
                        onChanged: (DateTime? selectedDate) {
                          baseDayForWeekly =
                              ByWeekDayEntry(selectedDate!.weekday);
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200,
                            child: FormBuilderDateTimePicker(
                              name: 'initial_activity_start',
                              initialTime:
                                  const TimeOfDay(hour: 09, minute: 10),
                              initialValue: DateTime.now().copyWith(
                                hour: 09,
                                minute: 10,
                              ),
                              inputType: InputType.time,
                              validator: FormBuilderValidators.required(),
                              decoration:
                                  const InputDecoration(labelText: 'Starts at'),
                              onChanged: (DateTime? newStartTime) {
                                if (newStartTime == null) {
                                  return;
                                }
                                final DateTime newArrivalTime = newStartTime
                                    .subtract(const Duration(minutes: 30));
                                formKey.currentState!.fields['initial_arrival']!
                                    .didChange(newArrivalTime);
                              },
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: FormBuilderDateTimePicker(
                              name: 'initial_activity_end',
                              initialTime:
                                  const TimeOfDay(hour: 14, minute: 50),
                              initialValue: DateTime.now().copyWith(
                                hour: 14,
                                minute: 50,
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: FormBuilderValidators.compose(
                                [
                                  FormBuilderValidators.required(),
                                  (date) {
                                    final TimeOfDay selectedFinishTime =
                                        TimeOfDay.fromDateTime(date!);
                                    final DateTime selectedStartDateTime =
                                        formKey
                                            .currentState!
                                            .fields['initial_activity_start']!
                                            .value!;
                                    final TimeOfDay selectedStartTime =
                                        TimeOfDay.fromDateTime(
                                            selectedStartDateTime);
                                    int finishTimeMinutes =
                                        selectedFinishTime.hour * 60 +
                                            selectedFinishTime.minute;
                                    int startTimeMinutes =
                                        selectedStartTime.hour * 60 +
                                            selectedStartTime.minute;
                                    if (finishTimeMinutes <= startTimeMinutes) {
                                      return 'Finish time must be after start time';
                                    }
                                    return null;
                                  }
                                ],
                              ),
                              inputType: InputType.time,
                              decoration: const InputDecoration(
                                  labelText: 'Finishes at'),
                              onChanged: (DateTime? newEndTime) {
                                if (newEndTime == null) {
                                  return;
                                }
                                final DateTime newLeaveTime =
                                    newEndTime.add(const Duration(minutes: 30));
                                formKey.currentState!.fields['initial_leave']!
                                    .didChange(newLeaveTime);
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200,
                            child: FormBuilderDateTimePicker(
                              name: 'initial_arrival',
                              initialTime:
                                  const TimeOfDay(hour: 08, minute: 40),
                              initialValue: DateTime.now().copyWith(
                                hour: 08,
                                minute: 40,
                              ),
                              inputType: InputType.time,
                              validator: FormBuilderValidators.required(),
                              decoration:
                                  const InputDecoration(labelText: 'Arrive at'),
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: FormBuilderDateTimePicker(
                              name: 'initial_leave',
                              initialTime:
                                  const TimeOfDay(hour: 15, minute: 20),
                              initialValue: DateTime.now().copyWith(
                                hour: 15,
                                minute: 20,
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: FormBuilderValidators.compose(
                                [
                                  FormBuilderValidators.required(),
                                  (date) {
                                    final TimeOfDay selectedFinishTime =
                                        TimeOfDay.fromDateTime(date!);
                                    final DateTime selectedStartDateTime =
                                        formKey.currentState!
                                            .fields['initial_arrival']!.value!;
                                    final TimeOfDay selectedStartTime =
                                        TimeOfDay.fromDateTime(
                                            selectedStartDateTime);
                                    int finishTimeMinutes =
                                        selectedFinishTime.hour * 60 +
                                            selectedFinishTime.minute;
                                    int startTimeMinutes =
                                        selectedStartTime.hour * 60 +
                                            selectedStartTime.minute;
                                    if (finishTimeMinutes <= startTimeMinutes) {
                                      return 'Leave time must be after Arrival time';
                                    }
                                    return null;
                                  }
                                ],
                              ),
                              inputType: InputType.time,
                              decoration:
                                  const InputDecoration(labelText: 'Leave at'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(),
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      FormBuilderCheckbox(
                        name: "doesRecur",
                        title: const Text("Does this booking recur?"),
                        initialValue: false,
                        onChanged: (bool? value) {
                          setState(() {
                            isBookingRecurring = value!;
                          });
                        },
                      ),
                      if (isBookingRecurring)
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Flexible(child: Text('Repeats every')),
                                const Flexible(
                                  child: NumberPickerFormField(
                                    name: "interval",
                                  ),
                                ),
                                Flexible(
                                  child: FormBuilderDropdown(
                                    name: 'frequency',
                                    items: [
                                      'Days',
                                      'Weeks',
                                    ]
                                        .map(
                                          (type) => DropdownMenuItem(
                                            value: type,
                                            child: Text(type),
                                          ),
                                        )
                                        .toList(),
                                    initialValue: "Weeks",
                                    valueTransformer: (String? freqString) {
                                      if (freqString == 'Days') {
                                        return Frequency.daily;
                                      } else {
                                        return Frequency.weekly;
                                      }
                                    },
                                    onChanged: (String? value) {
                                      if (value == 'Days') {
                                        setState(() {
                                          recursWeekly = false;
                                        });
                                      } else {
                                        setState(() {
                                          recursWeekly = true;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const Gap(20),
                            if (recursWeekly)
                              FormBuilderFilterChip<ByWeekDayEntry>(
                                direction: Axis.horizontal,
                                decoration: const InputDecoration(
                                  labelText: 'Every Week On The Days:',
                                  border: OutlineInputBorder(),
                                ),
                                name: "days_recurring_for_weekly",
                                initialValue: [baseDayForWeekly],
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: recursWeekly
                                    ? FormBuilderValidators.compose([
                                        FormBuilderValidators.required(),
                                        (List<ByWeekDayEntry>? value) {
                                          if (value == null) {
                                            return null;
                                          }
                                          if (!value
                                              .contains(baseDayForWeekly)) {
                                            return 'Please select $baseDayForWeekly';
                                          }
                                          return null;
                                        }
                                      ])
                                    : null,
                                options: [
                                  FormBuilderChipOption(
                                    value: ByWeekDayEntry(DateTime.monday),
                                  ),
                                  FormBuilderChipOption(
                                    value: ByWeekDayEntry(DateTime.tuesday),
                                  ),
                                  FormBuilderChipOption(
                                    value: ByWeekDayEntry(DateTime.wednesday),
                                  ),
                                  FormBuilderChipOption(
                                    value: ByWeekDayEntry(DateTime.thursday),
                                  ),
                                  FormBuilderChipOption(
                                    value: ByWeekDayEntry(DateTime.friday),
                                  ),
                                  FormBuilderChipOption(
                                    value: ByWeekDayEntry(DateTime.saturday),
                                  ),
                                  FormBuilderChipOption(
                                    value: ByWeekDayEntry(DateTime.sunday),
                                  ),
                                ],
                              ),
                            const Gap(20),
                            const Row(
                              children: [
                                Flexible(child: Text("Lasts for")),
                                Flexible(
                                  child: NumberPickerFormField(
                                      name: "number_of_sessions"),
                                ),
                                Flexible(child: Text("sessions")),
                              ],
                            )
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: FilledButton(
            onPressed: () {
              if (formKey.currentState!.saveAndValidate()) {
                final data = formKey.currentState!.value;
                final DateTime initialDate = data['initialDate'];

                final initialActivityStartTime = data['initial_activity_start'];
                final initialActivityEndTime = data['initial_activity_end'];
                final initialArrivalTime = data['initial_arrival'];
                final initialLeaveTime = data['initial_leave'];

                final initialActivityStart = initialDate.copyWith(
                  hour: initialActivityStartTime.hour,
                  minute: initialActivityStartTime.minute,
                );
                final initialActivityEnd = initialDate.copyWith(
                  hour: initialActivityEndTime.hour,
                  minute: initialActivityEndTime.minute,
                );
                final initialArrival = initialDate.copyWith(
                  hour: initialArrivalTime.hour,
                  minute: initialArrivalTime.minute,
                );
                final initialLeave = initialDate.copyWith(
                  hour: initialLeaveTime.hour,
                  minute: initialLeaveTime.minute,
                );

                final bool doesRecur = data['doesRecur'];
                RecurrenceRule? recurrenceRules;
                if (doesRecur) {
                  final int interval = data['interval'];
                  final Frequency frequency = data['frequency'];
                  final List<ByWeekDayEntry> byWeekDayEntry =
                      List.from(data['days_recurring_for_weekly']);
                  final numberOfSessions = data['number_of_sessions'];
                  if (frequency == Frequency.daily) {
                    recurrenceRules = RecurrenceRule(
                      frequency: Frequency.daily,
                      interval: interval,
                      count: numberOfSessions,
                    );
                  } else {
                    recurrenceRules = RecurrenceRule(
                        frequency: Frequency.weekly,
                        interval: interval,
                        count: numberOfSessions,
                        byWeekDays: byWeekDayEntry);
                  }
                }

                final FirebaseFirestore db = FirebaseFirestore.instance;
                final booking = Booking(
                  id: db.collection('bookings').doc().id,
                  coachTravelEstimates: [],
                  activity: widget.selectedActivity,
                  initialActivityStart: initialActivityStart,
                  initialActivityEnd: initialActivityEnd,
                  initialArrival: initialArrival,
                  initialLeave: initialLeave,
                  recurrenceRules: recurrenceRules,
                  client: widget.selectedClient,
                );
                GoRouter.of(context).go('/adminTools/createManualBooking/coach',
                    extra: booking);
              }
            },
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }
}

class DateFormat {}
