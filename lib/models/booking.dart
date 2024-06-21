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
  final DateTime initialActivityStart;
  final DateTime initialActivityEnd;
  final DateTime initialArrival;
  final DateTime initialLeave;

  final RecurrenceRule? recurrenceRules;
  final Client client;
  Query<Map<String, dynamic>>? sessionsRef;
  final bool isCustom;

  Booking({
    required this.id,
    required this.coachIds,
    required this.activity,
    required this.initialActivityStart,
    required this.initialActivityEnd,
    required this.initialArrival,
    required this.initialLeave,
    this.recurrenceRules,
    required this.client,
    this.isCustom = false,
  }) {
    sessionsRef = FirebaseFirestore.instance
        .collection('sessions')
        .where('bookingId', isEqualTo: id);
  }

  List<Session> generateStandardSessions() {
    if (recurrenceRules == null) {
      return [
        Session(
          startTime: initialActivityStart,
          endTime: initialActivityEnd,
          arrivalTime: initialArrival,
          leaveTime: initialLeave,
          bookingId: id,
          coachIds: coachIds,
          activity: activity,
          client: client,
          bookingRef: FirebaseFirestore.instance.collection('bookings').doc(id),
        ),
      ];
    }
    final List<Session> sessions = [];
    final List<DateTime> dates = recurrenceRules!.getAllInstances(
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
      'initialActivityStart': initialActivityStart.toIso8601String(),
      'initialActivityEnd': initialActivityEnd.toIso8601String(),
      'initialArrival': initialArrival.toIso8601String(),
      'initialLeave': initialLeave.toIso8601String(),
      'recurrenceProperties': recurrenceRules.toString(),
      'client': client.toJson(),
    };
  }

  Map<String, dynamic> toFBJson() {
    return {
      'coachIds': coachIds,
      'activity': activity.toJson(),
      'startTime': initialActivityStart.toIso8601String(),
      'endTime': '${initialActivityEnd.hour}:${initialActivityEnd.minute}',
      'initialArrival': initialArrival.toIso8601String(),
      'initialLeave': initialLeave.toIso8601String(),
      'recurrenceProperties': recurrenceRules,
      'client': client.toJson(),
    };
  }

  factory Booking.fromQueryDocSnapshot(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final String id = doc.id;
    final List<String> coachIds = List<String>.from(data['coachIds']);
    final Activity activity = Activity.fromJson(data['activity']);
    final DateTime initialActivityStart = DateTime.parse(data['startTime']);
    final DateTime initialActivityEnd = DateTime.parse(data['endTime']);
    final DateTime initialArrival = DateTime.parse(data['initialArrival']);
    final DateTime initialLeave = DateTime.parse(data['initialLeave']);
    final String? recurrenceRulesJson = data['recurrenceProperties'];
    final RecurrenceRule? recurrenceProperties = recurrenceRulesJson != null
        ? RecurrenceRule.fromJson(jsonDecode(recurrenceRulesJson))
        : null;
    final Client client = Client.fromJson(data['client'], doc.id);
    return Booking(
      id: id,
      coachIds: coachIds,
      activity: activity,
      initialActivityStart: initialActivityStart,
      initialActivityEnd: initialActivityEnd,
      initialArrival: initialArrival,
      initialLeave: initialLeave,
      recurrenceRules: recurrenceProperties,
      client: client,
    );
  }

  Booking copyWith({
    String? id,
    List<String>? coachIds,
    Activity? activity,
    DateTime? initialActivityStart,
    DateTime? initialActivityEnd,
    DateTime? initialArrival,
    DateTime? initialLeave,
    RecurrenceRule? recurrenceRules,
    Client? client,
  }) {
    return Booking(
      id: id ?? this.id,
      coachIds: coachIds ?? this.coachIds,
      activity: activity ?? this.activity,
      initialActivityStart: initialActivityStart ?? this.initialActivityStart,
      initialActivityEnd: initialActivityEnd ?? this.initialActivityEnd,
      initialArrival: initialArrival ?? this.initialArrival,
      initialLeave: initialLeave ?? this.initialLeave,
      recurrenceRules: recurrenceRules ?? recurrenceRules,
      client: client ?? this.client,
    );
  }
}
