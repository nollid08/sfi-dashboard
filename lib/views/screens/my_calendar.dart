import 'package:dashboard/models/booking.dart';
import 'package:dashboard/providers/my_calendar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MyCalendar extends ConsumerWidget {
  const MyCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Booking>> myCalendar = ref.watch(myCalendarProvider);

    return Center(
      child: myCalendar.when(
        data: (List<Booking>? bookings) {
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
                dataSource: CoachCalendarSource.fromBookings(bookings!),
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

  factory CoachCalendarSource.fromBookings(List<Booking> bookings) {
    return CoachCalendarSource(
      bookings
          .map<Appointment>(
            (Booking booking) => Appointment(
              startTime: booking.startDateTime,
              endTime: DateTime(
                  booking.startDateTime.year,
                  booking.startDateTime.month,
                  booking.startDateTime.day,
                  booking.endTime.hour,
                  booking.endTime.minute),
              subject: 'Meeting',
              color: Colors.blue,
              recurrenceRule: booking.recurrenceProperties,
            ),
          )
          .toList(),
    );
  }
}
