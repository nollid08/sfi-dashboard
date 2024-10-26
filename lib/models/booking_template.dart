import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/activity.dart';
import 'package:dashboard/models/assigned_coach.dart';
import 'package:dashboard/models/booking.dart';
import 'package:dashboard/models/client.dart';
import 'package:dashboard/models/session.dart';
import 'package:rrule/rrule.dart';

class BookingTemplate {
  final String bookingId;
  final List<AssignedCoach> assignedCoaches;
  final Activity activity;
  final List<Session> sessions;
  final Client client;
  Query<Map<String, dynamic>>? sessionsRef;

  BookingTemplate({
    required this.bookingId,
    required this.assignedCoaches,
    required this.activity,
    required this.sessions,
    required this.client,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'assignedCoaches': assignedCoaches.map((ac) => ac.toJson()).toList(),
      'activity': activity.toJson(),
      'sessions': sessions.map((session) => session.toJson()).toList(),
      'client': client.toJson(),
    };
  }

  BookingTemplate copyWith({
    String? bookingId,
    List<AssignedCoach>? assignedCoaches,
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
              assignedCoaches: assignedCoaches ?? this.assignedCoaches,
              activity: activity ?? this.activity,
              client: client ?? this.client,
            );
            return updatedSession;
          }).toList()
        : this.sessions.map((session) {
            final Session updatedSession = session.copyWith(
              bookingId: bookingId ?? this.bookingId,
              assignedCoaches: assignedCoaches ?? this.assignedCoaches,
              activity: activity ?? this.activity,
              client: client ?? this.client,
            );
            return updatedSession;
          }).toList();

    return BookingTemplate(
      bookingId: bookingId ?? this.bookingId,
      assignedCoaches: assignedCoaches ?? this.assignedCoaches,
      activity: activity ?? this.activity,
      sessions: updatedSessions,
      client: client ?? this.client,
    );
  }

  static Future<BookingTemplate> fromBooking(Booking booking) async {
    final List<AssignedCoach> assignedCoaches = [];
    final Activity activity = booking.activity;
    final sessionsRef = booking.sessionsRef;
    final List<Session> sessions = await sessionsRef?.get().then((value) =>
            value.docs.map((doc) => Session.fromDocSnapshot(doc)).toList()) ??
        [];
    final Client client = booking.client;

    return BookingTemplate(
      bookingId: booking.id,
      assignedCoaches: assignedCoaches,
      activity: activity,
      sessions: sessions,
      client: client,
    );
  }
}
