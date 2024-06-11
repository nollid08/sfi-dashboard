import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Booking {
  final String id;
  final List<String> coachIds;
  final String activityId;
  final DateTime startDateTime;
  final TimeOfDay endTime;
  final String recurrenceProperties;
  final String clientId;

  Booking({
    required this.id,
    required this.coachIds,
    required this.activityId,
    required this.startDateTime,
    required this.endTime,
    required this.recurrenceProperties,
    required this.clientId,
  });

  Map<String, dynamic> toJson() {
    return {
      'coachIds': coachIds,
      'activityId': activityId,
      'startTime': startDateTime.toIso8601String(),
      'endTime': "${endTime.hour}:${endTime.minute}",
      'recurrenceProperties': recurrenceProperties,
      'clientId': clientId,
    };
  }

  factory Booking.fromQueryDocSnapshot(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Booking(
      id: doc.id,
      coachIds: List<String>.from(data['coachIds']),
      activityId: data['activityId'],
      startDateTime: DateTime.parse(data['startTime']),
      endTime: TimeOfDay(
        hour: int.parse(data['endTime'].split(':')[0]),
        minute: int.parse(data['endTime'].split(':')[1]),
      ),
      recurrenceProperties: data['recurrenceProperties'],
      clientId: data['clientId'],
    );
  }
}
