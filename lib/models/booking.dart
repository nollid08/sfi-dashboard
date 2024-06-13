import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/activity.dart';
import 'package:dashboard/models/client.dart';
import 'package:flutter/material.dart';

class Booking {
  final String id;
  final List<String> coachIds;
  final Activity activity;
  final DateTime startDateTime;
  final TimeOfDay endTime;
  final String? recurrenceProperties;
  final Client client;

  Booking({
    required this.id,
    required this.coachIds,
    required this.activity,
    required this.startDateTime,
    required this.endTime,
    this.recurrenceProperties,
    required this.client,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coachIds': coachIds,
      'activity': activity.toJson(),
      'startTime': startDateTime.toIso8601String(),
      'endTime': "${endTime.hour}:${endTime.minute}",
      'recurrenceProperties': recurrenceProperties,
      'client': client.toJson(),
    };
  }

  factory Booking.fromQueryDocSnapshot(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Booking(
      id: doc.id,
      coachIds: List<String>.from(data['coachIds']),
      activity: Activity.fromQueryDocSnapshot(data['activity']),
      startDateTime: DateTime.parse(data['startTime']),
      endTime: TimeOfDay(
        hour: int.parse(data['endTime'].split(':')[0]),
        minute: int.parse(data['endTime'].split(':')[1]),
      ),
      recurrenceProperties: data['recurrenceProperties'],
      client: Client.fromJson(data['client'], data['client']['id']),
    );
  }
}
