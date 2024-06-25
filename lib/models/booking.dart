import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/activity.dart';
import 'package:dashboard/models/booking_template.dart';
import 'package:dashboard/models/client.dart';
import 'package:dashboard/models/coach.dart';
import 'package:dashboard/models/coach_travel_estimate.dart';
import 'package:rrule/rrule.dart';

class Booking {
  final String id;
  final Activity activity;
  final List<String> coachesUids;
  final Client client;
  Query<Map<String, dynamic>>? sessionsRef;

  Booking({
    required this.id,
    required this.coachesUids,
    required this.activity,
    required this.client,
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
    };
  }

  Map<String, dynamic> toFBJson() {
    return {
      'activity': activity.toJson(),
      'coaches': coachesUids,
      'client': client.toJson(),
    };
  }

  factory Booking.fromQueryDocSnapshot(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final String id = doc.id;
    final Activity activity = Activity.fromJson(data['activity']);
    final Client client = Client.fromJson(data['client'], doc.id);
    final List<String> coaches = data['coaches'];
    return Booking(
      id: id,
      activity: activity,
      coachesUids: coaches,
      client: client,
    );
  }

  factory Booking.fromBookingTemplate(BookingTemplate bookingTemplate) {
    final List<String> coaches = bookingTemplate.coachTravelEstimates
        .map((cte) => cte.coach.uid)
        .toList();
    return Booking(
      id: bookingTemplate.bookingId,
      activity: bookingTemplate.activity,
      coachesUids: coaches,
      client: bookingTemplate.client,
    );
  }

  Booking copyWith({
    String? id,
    List<CoachTravelEstimate>? coachTravelEstimates,
    Activity? activity,
    DateTime? initialActivityStart,
    DateTime? initialActivityEnd,
    DateTime? initialArrival,
    DateTime? initialLeave,
    RecurrenceRule? recurrenceRules,
    List<String>? coachesUids,
    Client? client,
  }) {
    return Booking(
      id: id ?? this.id,
      coachesUids: coachesUids ?? this.coachesUids,
      activity: activity ?? this.activity,
      client: client ?? this.client,
    );
  }
}
