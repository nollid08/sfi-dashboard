import 'package:dashboard/models/coach.dart';
import 'package:dashboard/models/leave.dart';
import 'package:dashboard/models/session.dart';
import 'package:flutter/material.dart';
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
    required List<Leave> leaves,
  }) {
    final List<Appointment> appointments = sessions
            .map<Appointment>(
              (Session session) => Appointment(
                startTime: session.startTime,
                endTime: session.endTime,
                subject: '${session.activity.name} @ ${session.client.town}',
                color: session.activity.color,
                location: session.bookingId,
                resourceIds:
                    session.assignedCoaches.map((ac) => ac.coach.uid).toList(),
              ),
            )
            .toList() +
        leaves.map<Appointment>((Leave leave) {
          return Appointment(
            startTime: leave.startDate,
            endTime: leave.endDate,
            resourceIds: [leave.coachUid],
            subject: leave.status == LeaveStatus.approved
                ? 'Approved Leave'
                : leave.status == LeaveStatus.pending
                    ? 'Pending Leave'
                    : leave.status == LeaveStatus.completed
                        ? 'Completed Leave'
                        : 'Current Leave',
            color: leave.status == LeaveStatus.approved
                ? Colors.red
                : leave.status == LeaveStatus.pending
                    ? Colors.orange
                    : leave.status == LeaveStatus.completed
                        ? Colors.yellow
                        : Colors.yellow,
          );
        }).toList();

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
