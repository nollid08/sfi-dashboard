import 'package:dashboard/models/coach_calendar_source.dart';
import 'package:dashboard/providers/my_calendar_provider.dart';
import 'package:dashboard/views/widgets/calendar.dart';
import 'package:dashboard/views/widgets/request_annual_leave_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:maps_launcher/maps_launcher.dart';

class MyCalendar extends ConsumerWidget {
  const MyCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<CoachCalendarSource> myCalendar =
        ref.watch(myCalendarProvider);

    final calendarController = CalendarController();
    return myCalendar.when(
      data: (CoachCalendarSource? coachCalendarSource) {
        return Card(
          margin: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Calendar(
                      calendarController: calendarController,
                      coachCalendarSource: coachCalendarSource!),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilledButton.icon(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return RequestAnnualLeaveDialog(
                              coachUid: FirebaseAuth.instance.currentUser!.uid,
                            );
                          },
                        );
                      },
                      label: const Text('Request Annual Leave'),
                      icon: const Icon(Icons.beach_access),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
      loading: () {
        return const CircularProgressIndicator();
      },
      error: (error, stackTrace) {
        throw error;
      },
    );
  }
}
