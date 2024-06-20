import 'package:dashboard/models/booking.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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
              location:
                  ' ${booking.client.eircode}, ${booking.client.addressLineOne}, ${booking.client.addressLineTwo}',
              subject: '${booking.activity.name} - ${booking.client.name}',
              color: booking.activity.color,
              recurrenceRule: booking.recurrenceProperties,
            ),
          )
          .toList(),
    );
  }
}
