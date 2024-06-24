import 'package:dashboard/models/booking.dart';
import 'package:dashboard/models/coach_travel_estimate.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CoachCalendarSource extends CalendarDataSource {
  CoachCalendarSource(List<Appointment> source) {
    appointments = source;
  }

  factory CoachCalendarSource.fromBookings(
      List<Booking> bookings, String? coachUid) {
    final List<Appointment> appointments = [];
    for (final booking in bookings) {
      final String? recurrenceRule = booking.recurrenceRules?.toString();
      //Remove RRULE: from the start of the string
      final String? recurrenceRuleString = recurrenceRule?.substring(6);
      appointments.add(
        Appointment(
          startTime: booking.initialArrival,
          endTime: booking.initialLeave,
          location:
              ' ${booking.client.eircode}, ${booking.client.addressLineOne}, ${booking.client.addressLineTwo}',
          subject: '${booking.activity.name} - ${booking.client.name}',
          color: booking.activity.color,
          recurrenceRule: recurrenceRuleString,
        ),
      );
      if (coachUid != null) {
        final CoachTravelEstimate coachTravelEstimate = booking
            .coachTravelEstimates
            .where((cte) => cte.coach.uid == coachUid)
            .first;
        final Duration travelTime = coachTravelEstimate.duration;
        final DateTime leaveHome = booking.initialArrival.subtract(travelTime);
        final DateTime arriveHome = booking.initialLeave.add(travelTime);
        appointments.add(Appointment(
          startTime: leaveHome,
          endTime: booking.initialArrival,
          color: Colors.grey,
          subject: 'Commute',
        ));

        appointments.add(Appointment(
          startTime: booking.initialLeave,
          endTime: arriveHome,
          color: Colors.grey,
          subject: 'Commute',
        ));
      }
    }
    return CoachCalendarSource(appointments);
  }
}
