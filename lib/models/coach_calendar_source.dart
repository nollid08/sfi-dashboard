import 'package:dashboard/models/booking.dart';
import 'package:dashboard/models/coach_travel_estimate.dart';
import 'package:dashboard/models/session.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CoachCalendarSource extends CalendarDataSource {
  CoachCalendarSource(List<Appointment> source) {
    appointments = source;
  }

  factory CoachCalendarSource.fromSessions({
    required List<Session> sessions,
    required String? coachUid,
  }) {
    final List<Appointment> appointments = [];
    for (final session in sessions) {
      appointments.add(
        Appointment(
          startTime: session.arrivalTime,
          endTime: session.leaveTime,
          location:
              ' ${session.client.eircode}, ${session.client.addressLineOne}, ${session.client.addressLineTwo}',
          subject: '${session.activity.name} - ${session.client.name}',
          color: session.activity.color,
        ),
      );
      if (coachUid != null) {
        final CoachTravelEstimate coachTravelEstimate = session
            .coachTravelEstimates
            .where((cte) => cte.coach.uid == coachUid)
            .first;
        final Duration travelTime = coachTravelEstimate.duration;
        final DateTime leaveHome = session.arrivalTime.subtract(travelTime);
        final DateTime arriveHome = session.leaveTime.add(travelTime);
        appointments.add(Appointment(
          startTime: leaveHome,
          endTime: session.arrivalTime,
          color: Colors.grey,
          subject: 'Commute',
        ));

        appointments.add(Appointment(
          startTime: session.leaveTime,
          endTime: arriveHome,
          color: Colors.grey,
          subject: 'Commute',
        ));
      }
    }
    return CoachCalendarSource(appointments);
  }
}
