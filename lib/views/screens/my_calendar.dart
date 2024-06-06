import 'package:dashboard/providers/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MyCalendar extends ConsumerWidget {
  const MyCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userValue = ref.watch(authProvider); // Directly access the stream

    return Center(
      child: userValue.when(
        data: (User? user) {
          return Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SfCalendar(
                view: CalendarView.month,
                allowViewNavigation: true,
                allowAppointmentResize: false,
                allowDragAndDrop: false,
                showDatePickerButton: true,
                allowedViews: const [
                  CalendarView.day,
                  CalendarView.week,
                  CalendarView.month,
                  CalendarView.schedule,
                ],
                monthViewSettings: const MonthViewSettings(
                    agendaViewHeight: 100,
                    appointmentDisplayCount: 5,
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment),
                showCurrentTimeIndicator: true,
                showTodayButton: false,
                showNavigationArrow: true,
                showWeekNumber: true,
                dataSource: CoachCalendarSource([
                  Appointment(
                      startTime: DateTime.now(),
                      endTime: DateTime.now().add(const Duration(hours: 1)),
                      subject: 'Meeting',
                      color: Colors.blue),
                  Appointment(
                      startTime: DateTime.now().add(const Duration(hours: 1)),
                      endTime: DateTime.now().add(const Duration(hours: 2)),
                      subject: 'Meeting',
                      color: Colors.blue),
                  Appointment(
                      notes: "Fun + Fitness w/ Megan",
                      startTime: DateTime.now().add(const Duration(hours: 2)),
                      endTime: DateTime.now().add(const Duration(hours: 3)),
                      subject: 'Meeting',
                      color: Colors.blue),
                  Appointment(
                      startTime: DateTime.now().add(const Duration(hours: 3)),
                      endTime: DateTime.now().add(const Duration(hours: 4)),
                      subject: 'Meeting',
                      color: Colors.blue),
                ]),
              ),
            ),
          );
        },
        loading: () {
          return const CircularProgressIndicator();
        },
        error: (error, stackTrace) {
          return Text('Error: $error');
        },
      ),
    );
  }
}

class CoachCalendarSource extends CalendarDataSource {
  CoachCalendarSource(List<Appointment> source) {
    appointments = source;
  }
}
