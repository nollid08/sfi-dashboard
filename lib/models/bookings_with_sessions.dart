//Extend booking class to contain all session rather than a session ref
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/activity.dart';
import 'package:dashboard/models/booking.dart';
import 'package:dashboard/models/client.dart';
import 'package:dashboard/models/coach.dart';
import 'package:dashboard/models/session.dart';

class BookingWithSessions extends Booking {
  final List<Session> sessions;

  BookingWithSessions({
    required super.id,
    required super.coachesUids,
    required super.activity,
    required super.client,
    required super.startDate,
    required super.endDate,
    required super.notes,
    required this.sessions,
  });

  List<Coach> get coaches {
    final List<Coach> coaches = [];
    for (final session in sessions) {
      for (final assignedCoach in session.assignedCoaches) {
        final coach = assignedCoach.coach;
        //if uid is not already in the list
        if (!coaches.any((c) => c.uid == coach.uid)) {
          coaches.add(coach);
        }
      }
    }
    return coaches;
  }

  factory BookingWithSessions.fromQueryDocSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> doc, List<Session> sessions) {
    final data = doc.data();
    final String id = doc.id;
    final Activity activity = Activity.fromJson(data['activity']);
    final Client client = Client.fromFBJson(data['client'], doc.id);
    final coaches = List<String>.from(data['coaches']);

    return BookingWithSessions(
      id: id,
      activity: activity,
      coachesUids: coaches,
      client: client,
      sessions: sessions,
      endDate: data['endDate'],
      startDate: data['startDate'],
      notes: data['notes'],
    );
  }

  factory BookingWithSessions.fromDocSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc, List<Session> sessions) {
    final data = doc.data();
    if (data == null) {
      throw Exception('No Booking Exists Of ID ${doc.id}');
    }
    final String id = doc.id;
    final Activity activity = Activity.fromJson(data['activity']);
    final Client client = Client.fromFBJson(data['client'], doc.id);
    final coaches = List<String>.from(data['coaches']);
    return BookingWithSessions(
      id: id,
      activity: activity,
      coachesUids: coaches,
      client: client,
      sessions: sessions,
      endDate: data['endDate'],
      startDate: data['startDate'],
      notes: data['notes'],
    );
  }

  factory BookingWithSessions.fromBase(
      Booking booking, List<Session> sessions) {
    return BookingWithSessions(
      id: booking.id,
      activity: booking.activity,
      coachesUids: booking.coachesUids,
      client: booking.client,
      sessions: sessions.where((session) {
        return session.bookingId == booking.id;
      }).toList(),
      endDate: booking.endDate,
      startDate: booking.startDate,
      notes: booking.notes,
    );
  }

  @override
  BookingWithSessions copyWith({
    String? id,
    List<String>? coachesUids,
    Activity? activity,
    Client? client,
    DateTime? startDate,
    DateTime? endDate,
    List<Session>? sessions,
    String? notes,
  }) {
    return BookingWithSessions(
      id: id ?? this.id,
      coachesUids: coachesUids ?? this.coachesUids,
      activity: activity ?? this.activity,
      client: client ?? this.client,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      sessions: sessions ?? this.sessions,
      notes: notes ?? this.notes,
    );
  }
}
