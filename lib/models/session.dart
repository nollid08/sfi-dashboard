import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/activity.dart';
import 'package:dashboard/models/assigned_coach.dart';
import 'package:dashboard/models/client.dart';
import 'package:dashboard/models/travel_estimate.dart';
import 'package:rrule/rrule.dart';

class Session {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime arrivalTime;
  final DateTime leaveTime;
  final String bookingId;
  final String? notes;
  final List<AssignedCoach> assignedCoaches;
  final Activity activity;
  final Client client;
  final DocumentReference<Map<String, dynamic>> bookingRef;

  Session({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.arrivalTime,
    required this.leaveTime,
    required this.bookingId,
    required this.assignedCoaches,
    required this.activity,
    required this.client,
    required this.bookingRef,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'arrivalTime': arrivalTime.millisecondsSinceEpoch,
      'leaveTime': leaveTime.millisecondsSinceEpoch,
      'bookingId': bookingId,
      'assignedCoaches': assignedCoaches.map((ac) => ac.toJson()).toList(),
      'coaches': assignedCoaches.map((cte) => cte.coach.uid).toList(),
      'notes': notes,
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
      'notes': notes,
      'assignedCoaches': assignedCoaches.map((ac) => ac.toJson()).toList(),
      'coaches': assignedCoaches.map((cte) => cte.coach.uid).toList(),
      'activity': activity.toJson(),
      'client': client.toJson(),
    };
  }

  factory Session.fromQueryDocSnapshot(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final String id = doc.id;
    final Timestamp startTimestamp = data['startTime'];
    final Timestamp endTimestamp = data['endTime'];
    final Timestamp arrivalTimestamp = data['arrivalTime'];
    final Timestamp leaveTimestamp = data['leaveTime'];
    final String? notes = data['notes'];
    final DateTime startTime = startTimestamp.toDate();
    final DateTime endTime = endTimestamp.toDate();
    final DateTime arrivalTime = arrivalTimestamp.toDate();
    final DateTime leaveTime = leaveTimestamp.toDate();
    final String bookingId = data['bookingId'];
    final List<AssignedCoach> assignedCoaches = data['assignedCoaches']
        .map<AssignedCoach>(
          (assignedCoach) => AssignedCoach.fromJson(assignedCoach),
        )
        .toList();
    final Activity activity = Activity.fromJson(data['activity']);
    final Client client = Client.fromFBJson(data['client'], doc.id);
    return Session(
      id: id,
      startTime: startTime,
      endTime: endTime,
      arrivalTime: arrivalTime,
      leaveTime: leaveTime,
      bookingId: bookingId,
      notes: notes,
      assignedCoaches: assignedCoaches,
      activity: activity,
      client: client,
      bookingRef: doc.reference as DocumentReference<Map<String, dynamic>>,
    );
  }

  factory Session.fromDocSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final String id = doc.id;
    final Timestamp startTimestamp = data['startTime'];
    final Timestamp endTimestamp = data['endTime'];
    final Timestamp arrivalTimestamp = data['arrivalTime'];
    final Timestamp leaveTimestamp = data['leaveTime'];
    final DateTime startTime = startTimestamp.toDate();
    final DateTime endTime = endTimestamp.toDate();
    final DateTime arrivalTime = arrivalTimestamp.toDate();
    final DateTime leaveTime = leaveTimestamp.toDate();
    final String bookingId = data['bookingId'];
    final String? notes = data['notes'];
    final List<AssignedCoach> assignedCoaches = data['assignedCoaches']
        .map<AssignedCoach>(
          (assignedCoach) => AssignedCoach.fromJson(assignedCoach),
        )
        .toList();
    final Activity activity = Activity.fromJson(data['activity']);
    final Client client = Client.fromFBJson(data['client'], doc.id);
    return Session(
      id: id,
      startTime: startTime,
      endTime: endTime,
      arrivalTime: arrivalTime,
      leaveTime: leaveTime,
      bookingId: bookingId,
      notes: notes,
      assignedCoaches: assignedCoaches,
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
    required List<AssignedCoach> assignedCoaches,
    RecurrenceRule? recurrenceRules,
  }) {
    if (recurrenceRules == null) {
      //gen firebase doc id
      final id = FirebaseFirestore.instance.collection('sessions').doc().id;
      return [
        Session(
          id: id,
          startTime: initialActivityStart,
          endTime: initialActivityEnd,
          arrivalTime: initialArrival,
          leaveTime: initialLeave,
          bookingId: bookingId,
          assignedCoaches: assignedCoaches,
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
      final id = FirebaseFirestore.instance.collection('sessions').doc().id;
      sessions.add(
        Session(
          id: id,
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
          assignedCoaches: assignedCoaches,
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
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? arrivalTime,
    DateTime? leaveTime,
    String? bookingId,
    List<AssignedCoach>? assignedCoaches,
    String? notes,
    Activity? activity,
    Client? client,
    DocumentReference<Map<String, dynamic>>? bookingRef,
  }) {
    return Session(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      leaveTime: leaveTime ?? this.leaveTime,
      bookingId: bookingId ?? this.bookingId,
      assignedCoaches: assignedCoaches ?? this.assignedCoaches,
      notes: notes ?? this.notes,
      activity: activity ?? this.activity,
      client: client ?? this.client,
      bookingRef: bookingRef ?? this.bookingRef,
    );
  }
}
