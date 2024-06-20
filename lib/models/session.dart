import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/activity.dart';
import 'package:dashboard/models/client.dart';

class Session {
  final DateTime startTime;
  final DateTime endTime;
  final String bookingId;
  final List<String> coachIds;
  final Activity activity;
  final Client client;
  final DocumentReference<Map<String, dynamic>> bookingRef;

  Session({
    required this.startTime,
    required this.endTime,
    required this.bookingId,
    required this.coachIds,
    required this.activity,
    required this.client,
    required this.bookingRef,
  });

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'bookingId': bookingId,
      'coachIds': coachIds,
      'activity': activity.toJson(),
      'client': client.toJson(),
    };
  }

  factory Session.fromQueryDocSnapshot(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final DateTime startTime = DateTime.parse(data['startTime']);
    final DateTime endTime = DateTime.parse(data['endTime']);
    final String bookingId = data['bookingId'];
    final List<String> coachIds = List<String>.from(data['coachIds']);
    final Activity activity = Activity.fromJson(data['activity']);
    final Client client = Client.fromJson(data['client'], doc.id);
    return Session(
      startTime: startTime,
      endTime: endTime,
      bookingId: bookingId,
      coachIds: coachIds,
      activity: activity,
      client: client,
      bookingRef: doc.reference as DocumentReference<Map<String, dynamic>>,
    );
  }
}
