import 'package:dashboard/models/coach_calendar_source.dart';
import 'package:dashboard/models/leave.dart';
import 'package:dashboard/models/session.dart';
import 'package:dashboard/models/travel_info.dart';
import 'package:dashboard/views/widgets/leave_details_dialog.dart.dart';
import 'package:dashboard/views/widgets/session_info_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendar extends ConsumerWidget {
  const Calendar({
    super.key,
    required this.coachCalendarSource,
  });

  final CoachCalendarSource coachCalendarSource;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SfCalendar(
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
        loadMoreWidgetBuilder:
            (BuildContext context, LoadMoreCallback loadMoreAppointments) {
          return FutureBuilder<void>(
            future: loadMoreAppointments(),
            builder: (context, snapShot) {
              return Container(
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.blue)));
            },
          );
        },
        onTap: (CalendarTapDetails details) {
          if (details.targetElement == CalendarElement.appointment) {
            final Appointment appointment = details.appointments![0];
            if (appointment.id is Map<String, dynamic>) {
              final sessionData = appointment.id as Map<String, dynamic>;
              final Session session = sessionData['session'] as Session;
              final TravelInfo travelInfo = sessionData['travelInfo'];
              final int sessionIndex = sessionData['sessionIndex'];
              //Show appointment details
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SessionInfoDialog(
                    session: session,
                    sessionIndex: sessionIndex,
                    travelInfo: travelInfo,
                  );
                },
              );
            } else if (appointment.id is Leave) {
              final Leave leave = appointment.id as Leave;
              //Show appointment details
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return LeaveDetailsDialog(leave: leave);
                },
              );
            }
          }
        },
        monthViewSettings: const MonthViewSettings(
            agendaViewHeight: 100,
            appointmentDisplayCount: 5,
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        showCurrentTimeIndicator: true,
        showTodayButton: false,
        showNavigationArrow: true,
        showWeekNumber: true,
        dataSource: coachCalendarSource);
  }
}
