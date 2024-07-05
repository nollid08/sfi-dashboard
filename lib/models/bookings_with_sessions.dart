//Extend booking class to contain all session rather than a session ref
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/activity.dart';
import 'package:dashboard/models/booking.dart';
import 'package:dashboard/models/client.dart';
import 'package:dashboard/models/session.dart';

class BookingWithSessions extends Booking {
  final List<Session> sessions;

  BookingWithSessions({
    required super.id,
    required super.coachesUids,
    required super.activity,
    required super.client,
    required this.sessions,
  });

  factory BookingWithSessions.fromQueryDocSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> doc, List<Session> sessions) {
    final data = doc.data();
    final String id = doc.id;
    final Activity activity = Activity.fromJson(data['activity']);
    final Client client = Client.fromJson(data['client'], doc.id);
    final coaches = List<String>.from(data['coaches']);

    return BookingWithSessions(
      id: id,
      activity: activity,
      coachesUids: coaches,
      client: client,
      sessions: sessions,
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
    final Client client = Client.fromJson(data['client'], doc.id);
    final coaches = List<String>.from(data['coaches']);
    return BookingWithSessions(
      id: id,
      activity: activity,
      coachesUids: coaches,
      client: client,
      sessions: sessions,
    );
  }

  factory BookingWithSessions.fromBase(
      Booking booking, List<Session> sessions) {
    return BookingWithSessions(
      id: booking.id,
      activity: booking.activity,
      coachesUids: booking.coachesUids,
      client: booking.client,
      sessions: sessions,
    );
  }

  @override
  BookingWithSessions copyWith({
    String? id,
    Activity? activity,
    List<String>? coachesUids,
    Client? client,
    List<Session>? sessions,
  }) {
    return BookingWithSessions(
      id: id ?? this.id,
      coachesUids: coachesUids ?? this.coachesUids,
      activity: activity ?? this.activity,
      client: client ?? this.client,
      sessions: sessions ?? this.sessions,
    );
  }
}
