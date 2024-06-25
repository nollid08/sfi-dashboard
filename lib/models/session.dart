import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/activity.dart';
import 'package:dashboard/models/client.dart';
import 'package:dashboard/models/coach_travel_estimate.dart';
import 'package:rrule/rrule.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'arrivalTime': arrivalTime.millisecondsSinceEpoch,
      'leaveTime': leaveTime.millisecondsSinceEpoch,
      'bookingId': bookingId,
      'coachTravelEstimates':
          coachTravelEstimates.map((cte) => cte.toJson()).toList(),
      'coaches': coachTravelEstimates.map((cte) => cte.coach.uid).toList(),
      'activity': activity.toJson(),
      'client': client.toJson(),
    };
  }

  Map<String, dynamic> toDoc() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'arrivalTime': arrivalTime,
      'leaveTime': leaveTime,
      'bookingId': bookingId,
      'coachTravelEstimates':
          coachTravelEstimates.map((cte) => cte.toJson()).toList(),
      'coaches': coachTravelEstimates.map((cte) => cte.coach.uid).toList(),
      'activity': activity.toJson(),
      'client': client.toJson(),
    };
  }

  factory Session.fromQueryDocSnapshot(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final Timestamp startTimestamp = data['startTime'];
    final Timestamp endTimestamp = data['endTime'];
    final Timestamp arrivalTimestamp = data['arrivalTime'];
    final Timestamp leaveTimestamp = data['leaveTime'];
    final DateTime startTime = startTimestamp.toDate();
    final DateTime endTime = endTimestamp.toDate();
    final DateTime arrivalTime = arrivalTimestamp.toDate();
    final DateTime leaveTime = leaveTimestamp.toDate();
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

  static List<Session> generateStandardSessions({
    required String bookingId,
    required Activity activity,
    required Client client,
    required DateTime initialActivityStart,
    required DateTime initialActivityEnd,
    required DateTime initialArrival,
    required DateTime initialLeave,
    required List<CoachTravelEstimate> coachTravelEstimates,
    RecurrenceRule? recurrenceRules,
  }) {
    if (recurrenceRules == null) {
      return [
        Session(
          startTime: initialActivityStart,
          endTime: initialActivityEnd,
          arrivalTime: initialArrival,
          leaveTime: initialLeave,
          bookingId: bookingId,
          coachTravelEstimates: coachTravelEstimates,
          activity: activity,
          client: client,
          bookingRef:
              FirebaseFirestore.instance.collection('bookings').doc(bookingId),
        ),
      ];
    }
    final List<Session> sessions = [];
    final List<DateTime> dates = recurrenceRules.getAllInstances(
      start: initialActivityStart.copyWith(
        isUtc: true,
      ),
    );

    for (final date in dates) {
      sessions.add(
        Session(
          startTime: date,
          endTime: date.copyWith(
            hour: initialActivityEnd.hour,
            minute: initialActivityEnd.minute,
          ),
          arrivalTime: date.copyWith(
            hour: initialArrival.hour,
            minute: initialArrival.minute,
          ),
          leaveTime: date.copyWith(
            hour: initialLeave.hour,
            minute: initialLeave.minute,
          ),
          bookingId: bookingId,
          coachTravelEstimates: coachTravelEstimates,
          activity: activity,
          client: client,
          bookingRef:
              FirebaseFirestore.instance.collection('bookings').doc(bookingId),
        ),
      );
    }
    return sessions;
  }

  Session copyWith({
    DateTime? startTime,
    DateTime? endTime,
    DateTime? arrivalTime,
    DateTime? leaveTime,
    String? bookingId,
    List<CoachTravelEstimate>? coachTravelEstimates,
    Activity? activity,
    Client? client,
    DocumentReference<Map<String, dynamic>>? bookingRef,
  }) {
    return Session(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      leaveTime: leaveTime ?? this.leaveTime,
      bookingId: bookingId ?? this.bookingId,
      coachTravelEstimates: coachTravelEstimates ?? this.coachTravelEstimates,
      activity: activity ?? this.activity,
      client: client ?? this.client,
      bookingRef: bookingRef ?? this.bookingRef,
    );
  }
}
