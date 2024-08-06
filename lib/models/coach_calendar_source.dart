import 'package:dashboard/models/assigned_coach.dart';
import 'package:dashboard/models/leave.dart';
import 'package:dashboard/models/session.dart';
import 'package:dashboard/providers/effective_leaves.dart';
import 'package:dashboard/providers/sessions_provider.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CoachCalendarSource extends CalendarDataSource {
  final ProviderRef ref;
  final String coachUid;
  bool hasLoaded = false;
  CoachCalendarSource(List<Appointment> source,
      {required this.ref, required this.coachUid}) {
    appointments = source;
  }

  @override
  Future<void> handleLoadMore(DateTime startDate, DateTime endDate) async {
    final IList<String> prop = [coachUid].lock;
    final List<Session> sessions =
        await ref.read(sessionsProvider(coachIds: prop).future);
    final List<Leave> leaves =
        await ref.read(effectiveLeavesProvider(coachUid).future);
    final List<Appointment> newAppointments = appointmentsFromData(
      sessions: sessions,
      leaves: leaves,
      coachUid: coachUid,
    );
    appointments = [];
    notifyListeners(CalendarDataSourceAction.reset, appointments!);
    appointments?.addAll(newAppointments);
    notifyListeners(CalendarDataSourceAction.add, newAppointments);
    hasLoaded = true;
  }

  Future<void> invalidate() async {
    final IList<String> prop = [coachUid].lock;
    final List<Session> sessions =
        await ref.read(sessionsProvider(coachIds: prop).future);
    final List<Leave> leaves =
        await ref.read(effectiveLeavesProvider(coachUid).future);
    final List<Appointment> newAppointments = appointmentsFromData(
      sessions: sessions,
      leaves: leaves,
      coachUid: coachUid,
    );
    appointments = [];
    notifyListeners(CalendarDataSourceAction.reset, appointments!);
    appointments?.addAll(newAppointments);
    notifyListeners(CalendarDataSourceAction.add, newAppointments);
    hasLoaded = true;
  }

  List<Appointment> appointmentsFromData({
    required List<Session> sessions,
    required List<Leave> leaves,
    required String? coachUid,
  }) {
    sessions.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
    final List<Appointment> appointments = [];
    for (final leave in leaves) {
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
    return appointments;
  }
}
