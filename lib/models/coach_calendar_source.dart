import 'package:dashboard/models/booking.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CoachCalendarSource extends CalendarDataSource {
  CoachCalendarSource(List<Appointment> source) {
    appointments = source;
  }

  factory CoachCalendarSource.fromBookings(List<Booking> bookings) {
    return CoachCalendarSource(
      bookings.map<Appointment>((Booking booking) {
        final String recurrenceRule = booking.recurrenceRules.toString();
        //Remove RRULE: from the start of the string
        final String recurrenceRuleString = recurrenceRule.substring(6);
        return Appointment(
          startTime: booking.initialActivityStart,
          endTime: booking.initialActivityEnd,
          location:
              ' ${booking.client.eircode}, ${booking.client.addressLineOne}, ${booking.client.addressLineTwo}',
          subject: '${booking.activity.name} - ${booking.client.name}',
          color: booking.activity.color,
          recurrenceRule: recurrenceRuleString,
        );
      }).toList(),
    );
  }
}
