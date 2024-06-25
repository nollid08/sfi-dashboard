import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/activity.dart';
import 'package:dashboard/models/client.dart';
import 'package:dashboard/models/coach_travel_estimate.dart';
import 'package:dashboard/models/session.dart';
import 'package:rrule/rrule.dart';

class BookingTemplate {
  final String bookingId;
  final List<CoachTravelEstimate> coachTravelEstimates;
  final Activity activity;
  final List<Session> sessions;
  final Client client;
  Query<Map<String, dynamic>>? sessionsRef;

  BookingTemplate({
    required this.bookingId,
    required this.coachTravelEstimates,
    required this.activity,
    required this.sessions,
    required this.client,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'coachTravelEstimates':
          coachTravelEstimates.map((cte) => cte.toJson()).toList(),
      'activity': activity.toJson(),
      'sessions': sessions.map((session) => session.toJson()).toList(),
      'client': client.toJson(),
    };
  }

  BookingTemplate copyWith({
    String? bookingId,
    List<CoachTravelEstimate>? coachTravelEstimates,
    Activity? activity,
    List<Session>? sessions,
    RecurrenceRule? recurrenceRules,
    Client? client,
  }) {
    //Update all session with the new values
    final List<Session> updatedSessions = sessions != null
        ? sessions.map((session) {
            final Session updatedSession = session.copyWith(
              bookingId: bookingId ?? this.bookingId,
              coachTravelEstimates:
                  coachTravelEstimates ?? this.coachTravelEstimates,
              activity: activity ?? this.activity,
              client: client ?? this.client,
            );
            return updatedSession;
          }).toList()
        : this.sessions.map((session) {
            final Session updatedSession = session.copyWith(
              bookingId: bookingId ?? this.bookingId,
              coachTravelEstimates:
                  coachTravelEstimates ?? this.coachTravelEstimates,
              activity: activity ?? this.activity,
              client: client ?? this.client,
            );
            return updatedSession;
          }).toList();

    return BookingTemplate(
      bookingId: bookingId ?? this.bookingId,
      coachTravelEstimates: coachTravelEstimates ?? this.coachTravelEstimates,
      activity: activity ?? this.activity,
      sessions: updatedSessions,
      client: client ?? this.client,
    );
  }
}
