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
import 'package:syncfusion_flutter_calendar/calendar.dart';

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
  bool isFinishDateFieldEnabled = false;
  bool isBookingRecurring = false;
  bool showDayPicker = true;
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 200,
                        child: FormBuilderDateTimePicker(
                          name: 'start_date',
                          validator: FormBuilderValidators.required(),
                          decoration:
                              const InputDecoration(labelText: 'Starts at'),
                          onChanged: (DateTime? dateTime) {
                            if (dateTime != null) {
                              setState(() {
                                isFinishDateFieldEnabled = true;
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: FormBuilderDateTimePicker(
                          name: 'end_time',
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(),
                              (date) {
                                final minDateTime = formKey.currentState!
                                    .fields['start_date']!.value as DateTime?;
                                final minTime =
                                    TimeOfDay.fromDateTime(minDateTime!);
                                final selectedTime =
                                    TimeOfDay.fromDateTime(date!);
                                final comparableMinTime =
                                    minTime.hour * 60 + minTime.minute;
                                final comparableSelectedTime =
                                    selectedTime.hour * 60 +
                                        selectedTime.minute;
                                if (comparableSelectedTime <=
                                    comparableMinTime) {
                                  return 'End time must be after start time';
                                }
                                return null;
                              },
                            ],
                          ),
                          inputType: InputType.time,
                          //Only enable when other field is filled
                          enabled: isFinishDateFieldEnabled,
                          decoration:
                              const InputDecoration(labelText: 'Finishes at'),
                        ),
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
                                    name: "selected_interval",
                                  ),
                                ),
                                Flexible(
                                  child: FormBuilderDropdown(
                                    name: 'interval_type',
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
                                    onChanged: (String? value) {
                                      if (value == 'Days') {
                                        setState(() {
                                          showDayPicker = false;
                                        });
                                      } else {
                                        setState(() {
                                          showDayPicker = true;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const Gap(20),
                            if (showDayPicker)
                              FormBuilderFilterChip<String>(
                                direction: Axis.horizontal,
                                decoration: const InputDecoration(
                                  labelText: 'Recurs On:',
                                  border: OutlineInputBorder(),
                                ),
                                name: "days_recurring_for_weekly",
                                initialValue: const ["Monday"],
                                validator: FormBuilderValidators.required(),
                                options: const [
                                  FormBuilderChipOption(
                                    value: "Mo",
                                  ),
                                  FormBuilderChipOption(
                                    value: "Tu",
                                  ),
                                  FormBuilderChipOption(
                                    value: "We",
                                  ),
                                  FormBuilderChipOption(
                                    value: "Th",
                                  ),
                                  FormBuilderChipOption(
                                    value: "F",
                                  ),
                                  FormBuilderChipOption(
                                    value: "Sa",
                                  ),
                                  FormBuilderChipOption(
                                    value: "Su",
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
                final startDateTime = data['start_date'] as DateTime;
                final endDateTime = data['end_time'] as DateTime;
                final interval = data['selected_interval'] as int;
                final intervalType = data['interval_type'] as String;
                final daysRecurringForWeekly =
                    data['days_recurring_for_weekly'] as List<String>;
                final numberOfSessions = data['number_of_sessions'] as int;
                final doesRecur = data['doesRecur'] as bool;

                final endTime = TimeOfDay.fromDateTime(endDateTime);
                String? recurrenceProperties;
                if (doesRecur) {
                  if (intervalType == 'Days') {
                    recurrenceProperties =
                        "FREQ=DAILY;INTERVAL=$interval;COUNT=$numberOfSessions";
                  } else if (intervalType == 'Weeks') {
                    recurrenceProperties =
                        "FREQ=WEEKLY;INTERVAL=$interval;BYDAY=${daysRecurringForWeekly.join(',').toUpperCase()};COUNT=$numberOfSessions";
                  }
                }
                final booking = Booking(
                  id: '1',
                  coachIds: [
                    // "mkhK7z6u64gq7gyqt2zXD9sWIRV2",
                  ],
                  activity: widget.selectedActivity,
                  startDateTime: startDateTime,
                  endTime: endTime,
                  recurrenceProperties: recurrenceProperties,
                  client: widget.selectedClient,
                );

                // final FirebaseFirestore db = FirebaseFirestore.instance;
                // db.collection('bookings').add(booking.toJson());
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
