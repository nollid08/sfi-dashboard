import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/activity.dart';
import 'package:dashboard/models/client.dart';
import 'package:dashboard/models/session.dart';
import 'package:flutter/material.dart';
import 'package:rrule/rrule.dart';

class Booking {
  final String id;
  final List<String> coachIds;
  final Activity activity;
  final DateTime startDateTime;
  final TimeOfDay endTime;
  final String? recurrenceProperties;
  final Client client;
  Query<Map<String, dynamic>>? sessionsRef;
  final bool isCustom;

  Booking({
    required this.id,
    required this.coachIds,
    required this.activity,
    required this.startDateTime,
    required this.endTime,
    this.recurrenceProperties,
    required this.client,
    this.isCustom = false,
  }) {
    sessionsRef = FirebaseFirestore.instance
        .collection('sessions')
        .where('bookingId', isEqualTo: id);
  }

  List<Session> generateStandardSessions() {
    if (recurrenceProperties == null) {
      return [
        Session(
          startTime: startDateTime,
          endTime: DateTime(
            startDateTime.year,
            startDateTime.month,
            startDateTime.day,
            endTime.hour,
            endTime.minute,
          ),
          bookingId: id,
          coachIds: coachIds,
          activity: activity,
          client: client,
          bookingRef: FirebaseFirestore.instance.collection('bookings').doc(id),
        ),
      ];
    }
    final List<Session> sessions = [];
    // Sample Recureence Rule (As String) = RRULE:FREQ=WEEKLY;COUNT=8;BYDAY=WE
    final RecurrenceRule recRule =
        RecurrenceRule.fromString('RRULE:$recurrenceProperties');
    // RRULE:FREQ=WEEKLY;INTERVAL=2;BYDAY=TU,TH;BYMONTH=12
    final List<DateTime> dates = recRule.getAllInstances(
      start: startDateTime.copyWith(
        isUtc: true,
      ),
    );

    for (final date in dates) {
      sessions.add(
        Session(
          startTime: date,
          endTime: DateTime(
            date.year,
            date.month,
            date.day,
            endTime.hour,
            endTime.minute,
          ),
          bookingId: id,
          coachIds: coachIds,
          activity: activity,
          client: client,
          bookingRef: FirebaseFirestore.instance.collection('bookings').doc(id),
        ),
      );
    }
    return sessions;
  }

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

  Map<String, dynamic> toFBJson() {
    return {
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
    final String id = doc.id;
    final List<String> coachIds = List<String>.from(data['coachIds']);
    final Activity activity = Activity.fromJson(data['activity']);
    final DateTime startDateTime = DateTime.parse(data['startTime']);
    final TimeOfDay endTime = TimeOfDay(
      hour: int.parse(data['endTime'].split(':')[0]),
      minute: int.parse(data['endTime'].split(':')[1]),
    );
    final String? recurrenceProperties = data['recurrenceProperties'];
    final Client client = Client.fromJson(data['client'], doc.id);
    return Booking(
      id: id,
      coachIds: coachIds,
      activity: activity,
      startDateTime: startDateTime,
      endTime: endTime,
      recurrenceProperties: recurrenceProperties,
      client: client,
    );
  }

  Booking copyWith({
    String? id,
    List<String>? coachIds,
    Activity? activity,
    DateTime? startDateTime,
    TimeOfDay? endTime,
    String? recurrenceProperties,
    Client? client,
  }) {
    return Booking(
      id: id ?? this.id,
      coachIds: coachIds ?? this.coachIds,
      activity: activity ?? this.activity,
      startDateTime: startDateTime ?? this.startDateTime,
      endTime: endTime ?? this.endTime,
      recurrenceProperties: recurrenceProperties ?? this.recurrenceProperties,
      client: client ?? this.client,
    );
  }
}
