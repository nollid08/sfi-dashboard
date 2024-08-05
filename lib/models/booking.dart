import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/activity.dart';
import 'package:dashboard/models/booking_template.dart';
import 'package:dashboard/models/client.dart';
import 'package:dashboard/models/coach.dart';
import 'package:dashboard/models/session.dart';
import 'package:dashboard/models/travel_estimate.dart';
import 'package:rrule/rrule.dart';

class Booking {
  final String id;
  final Activity activity;
  final List<String> coachesUids;
  final Client client;
  final DateTime startDate;
  final DateTime endDate;
  Query<Map<String, dynamic>>? sessionsRef;

  Booking({
    required this.id,
    required this.coachesUids,
    required this.activity,
    required this.client,
    required this.startDate,
    required this.endDate,
  }) {
    sessionsRef = FirebaseFirestore.instance
        .collection('sessions')
        .where('bookingId', isEqualTo: id);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activity': activity.toJson(),
      'coaches': coachesUids,
      'client': client.toJson(),
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> toFBJson() {
    return {
      'activity': activity.toJson(),
      'coaches': coachesUids,
      'client': client.toJson(),
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  factory Booking.fromQueryDocSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final String id = doc.id;
    final Activity activity = Activity.fromJson(data['activity']);
    final Client client = Client.fromFBJson(data['client'], doc.id);
    final coaches = List<String>.from(data['coaches']);
    final DateTime startDate = data['startDate'].toDate();
    final DateTime endDate = data['endDate'].toDate();
    return Booking(
      id: id,
      activity: activity,
      coachesUids: coaches,
      client: client,
      startDate: startDate,
      endDate: endDate,
    );
  }

  factory Booking.fromDocSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception('No Booking Exists Of ID ${doc.id}');
    }
    final String id = doc.id;
    final Activity activity = Activity.fromJson(data['activity']);
    final Client client =
        Client.fromFBJson(data['client'], data['client']['id']);
    final coaches = List<String>.from(data['coaches']);
    final DateTime startDate = data['startDate'].toDate();
    final DateTime endDate = data['endDate'].toDate();
    return Booking(
      id: id,
      activity: activity,
      coachesUids: coaches,
      client: client,
      startDate: startDate,
      endDate: endDate,
    );
  }

  factory Booking.fromBookingTemplate(BookingTemplate bookingTemplate) {
    final List<String> coaches =
        bookingTemplate.assignedCoaches.map((ac) => ac.coach.uid).toList();
    final DateTime startDate = bookingTemplate.sessions.first.arrivalTime;
    final DateTime endDate = bookingTemplate.sessions.last.leaveTime;
    return Booking(
      id: bookingTemplate.bookingId,
      activity: bookingTemplate.activity,
      coachesUids: coaches,
      client: bookingTemplate.client,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Booking copyWith({
    String? id,
    Activity? activity,
    List<String>? coachesUids,
    Client? client,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Booking(
      id: id ?? this.id,
      activity: activity ?? this.activity,
      coachesUids: coachesUids ?? this.coachesUids,
      client: client ?? this.client,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
