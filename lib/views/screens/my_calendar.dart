import 'package:dashboard/models/booking.dart';
import 'package:dashboard/models/coach_calendar_source.dart';
import 'package:dashboard/providers/my_calendar_provider.dart';
import 'package:dashboard/views/widgets/hover_wrapper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MyCalendar extends ConsumerWidget {
  const MyCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Booking>> myCalendar = ref.watch(myCalendarProvider);
    final calendarController = CalendarController();
    return Center(
      child: myCalendar.when(
        data: (List<Booking>? bookings) {
          return Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SfCalendar(
                controller: calendarController,
                view: CalendarView.month,
                allowViewNavigation: true,
                allowAppointmentResize: false,
                allowDragAndDrop: false,
                showDatePickerButton: true,
                allowedViews: const [
                  CalendarView.day,
                  CalendarView.workWeek,
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
