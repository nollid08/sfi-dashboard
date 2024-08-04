import 'package:dashboard/models/assigned_coach.dart';
import 'package:dashboard/models/booking.dart';
import 'package:dashboard/models/functions.dart';
import 'package:dashboard/models/leave.dart';
import 'package:dashboard/models/travel_estimate.dart';
import 'package:dashboard/models/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CoachCalendarSource extends CalendarDataSource {
  CoachCalendarSource(List<Appointment> source) {
    appointments = source;
  }

  factory CoachCalendarSource.fromData({
    required List<Session> sessions,
    required List<Leave> leaves,
    required String? coachUid,
  }) {
    sessions.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
    final List<Appointment> appointments = [];
    for (final leave in leaves) {
      // final int daysCovered =
      //     inclusiveDaysBetween(leave.startDate, leave.endDate);
      // if (daysCovered == 1) {
      //   appointments.add(
      //     Appointment(
      //       startTime: leave.startDate,
      //       endTime: leave.endDate,
      //       subject: 'Leave',
      //       color: Colors.red,
      //       id: {"leave": leave},
      //     ),
      //   );
      // } else if (daysCovered == 2) {
      //   appointments.add(
      //     Appointment(
      //       startTime: leave.startDate,
      //       endTime: leave.startDate.copyWith(hour: 24),
      //       subject: 'Leave',
      //       color: Colors.red,
      //       id: {"leave": leave},
      //     ),
      //   );
      //   appointments.add(
      //     Appointment(
      //       startTime: leave.endDate.copyWith(hour: 0),
      //       endTime: leave.endDate,
      //       subject: 'Leave',
      //       color: Colors.red,
      //       id: {"leave": leave},
      //     ),
      //   );
      // } else {
      //   for (int i = 0; i < daysCovered; i++) {
      //     if (i == 0) {
      //       appointments.add(
      //         Appointment(
      //           startTime: leave.startDate,
      //           endTime: leave.startDate.copyWith(hour: 23, minute: 59),
      //           subject: 'Leave',
      //           color: Colors.red,
      //           id: {"leave": leave},
      //           isAllDay: false,
      //         ),
      //       );
      //     } else if (i == daysCovered - 1) {
      //       appointments.add(
      //         Appointment(
      //           startTime: leave.endDate.copyWith(
      //             hour: 0,
      //           ),
      //           endTime: leave.endDate,
      //           subject: 'Leave',
      //           color: Colors.red,
      //           id: {"leave": leave},
      //           isAllDay: false,
      //         ),
      //       );
      //     } else {
      //       appointments.add(
      //         Appointment(
      //           startTime: leave.startDate
      //               .add(Duration(days: i))
      //               .copyWith(hour: 0, minute: 1),
      //           endTime: leave.startDate
      //               .add(Duration(days: i))
      //               .copyWith(hour: 23, minute: 59),
      //           isAllDay: false,
      //           subject: 'Leave',
      //           color: Colors.red,
      //           id: {"leave": leave},
      //         ),
      //       );
      //     }
      //   }
      // }
      appointments.add(
        Appointment(
          startTime: leave.startDate,
          endTime: leave.endDate,
          id: leave,
          subject: leave.status == LeaveStatus.approved
              ? 'Approved Leave'
              : leave.status == LeaveStatus.pending
                  ? ' Pending Leave'
                  : leave.status == LeaveStatus.completed
                      ? ' Completed Leave'
                      : 'Current Leave',
          color: leave.status == LeaveStatus.approved
              ? Colors.red
              : leave.status == LeaveStatus.pending
                  ? Colors.orange
                  : leave.status == LeaveStatus.completed
                      ? Colors.yellow
                      : Colors.yellow,
        ),
      );
    }
    for (final session in sessions) {
      if (coachUid != null) {
        final AssignedCoach assignedCoach = session.assignedCoaches.firstWhere(
          (ac) => ac.coach.uid == coachUid,
        );

        appointments.add(
          Appointment(
              startTime: session.arrivalTime,
              endTime: session.leaveTime,
              location: ' ${session.client.eircode}',
              subject: '${session.activity.name} - ${session.client.name}',
              color: session.activity.color,
              id: {
                "sessionIndex": sessions.indexOf(session),
                "session": session,
                "travelInfo": assignedCoach.travelInfo,
              }),
        );
        final Duration travelTime = assignedCoach.travelInfo.duration;
        final DateTime leaveHome = session.arrivalTime.subtract(travelTime);
        final DateTime arriveHome = session.leaveTime.add(travelTime);
        appointments.add(Appointment(
            startTime: leaveHome,
            endTime: session.arrivalTime,
            color: Colors.grey,
            subject: 'Commute',
            id: {
              "sessionIndex": sessions.indexOf(session),
              "session": session,
              "travelInfo": assignedCoach.travelInfo,
            }));

        appointments.add(Appointment(
            startTime: session.leaveTime,
            endTime: arriveHome,
            color: Colors.grey,
            subject: 'Commute',
            id: {
              "sessionIndex": sessions.indexOf(session),
              "session": session,
              "travelInfo": assignedCoach.travelInfo,
            }));
      }
    }
    return CoachCalendarSource(appointments);
  }
}
