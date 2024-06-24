import 'package:dashboard/models/coach.dart';
import 'package:dashboard/models/coach_travel_estimate.dart';
import 'package:dashboard/models/session.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ResourceCalendarDataSource extends CalendarDataSource {
  ResourceCalendarDataSource(
      List<Appointment> source, List<CalendarResource> resourceColl) {
    appointments = source;
    resources = resourceColl;
  }

  factory ResourceCalendarDataSource.fromData({
    required List<Session> sessions,
    required List<Coach> coaches,
  }) {
    final List<Appointment> appointments = sessions
        .map<Appointment>(
          (Session session) => Appointment(
            startTime: session.startTime,
            endTime: session.endTime,
            subject:
                '${session.activity.name} @ ${session.client.addressLineOne}',
            color: session.activity.color,
            resourceIds: session.coachTravelEstimates
                .map((CoachTravelEstimate cte) => cte.coach.uid)
                .toList(),
          ),
        )
        .toList();

    final List<CalendarResource> resources = coaches
        .map<CalendarResource>(
          (
            Coach coach,
          ) =>
              CalendarResource(
            id: coach.uid,
            displayName: coach.name,
          ),
        )
        .toList();

    return ResourceCalendarDataSource(appointments, resources);
  }
}
