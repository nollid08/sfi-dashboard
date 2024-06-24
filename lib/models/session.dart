import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/activity.dart';
import 'package:dashboard/models/client.dart';
import 'package:dashboard/models/coach_travel_estimate.dart';

class Session {
  final DateTime startTime;
  final DateTime endTime;
  final DateTime arrivalTime;
  final DateTime leaveTime;
  final String bookingId;
  final List<CoachTravelEstimate> coachTravelEstimates;
  final Activity activity;
  final Client client;
  final DocumentReference<Map<String, dynamic>> bookingRef;

  Session({
    required this.startTime,
    required this.endTime,
    required this.arrivalTime,
    required this.leaveTime,
    required this.bookingId,
    required this.coachTravelEstimates,
    required this.activity,
    required this.client,
    required this.bookingRef,
  });

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'arrivalTime': arrivalTime.toIso8601String(),
      'leaveTime': leaveTime.toIso8601String(),
      'bookingId': bookingId,
      'coachTravelEstimates':
          coachTravelEstimates.map((cte) => cte.toJson()).toList(),
      'activity': activity.toJson(),
      'client': client.toJson(),
    };
  }

  factory Session.fromQueryDocSnapshot(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final DateTime startTime = DateTime.parse(data['startTime']);
    final DateTime endTime = DateTime.parse(data['endTime']);
    final DateTime arrivalTime = DateTime.parse(data['arrivalTime']);
    final DateTime leaveTime = DateTime.parse(data['leaveTime']);
    final String bookingId = data['bookingId'];
    final List<CoachTravelEstimate> coachTravelEstimates =
        data['coachTravelEstimates']
            .map<CoachTravelEstimate>(
              (cte) => CoachTravelEstimate.fromJson(cte),
            )
            .toList();
    final Activity activity = Activity.fromJson(data['activity']);
    final Client client = Client.fromJson(data['client'], doc.id);
    return Session(
      startTime: startTime,
      endTime: endTime,
      arrivalTime: arrivalTime,
      leaveTime: leaveTime,
      bookingId: bookingId,
      coachTravelEstimates: coachTravelEstimates,
      activity: activity,
      client: client,
      bookingRef: doc.reference as DocumentReference<Map<String, dynamic>>,
    );
  }
}
