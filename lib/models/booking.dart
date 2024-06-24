import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/activity.dart';
import 'package:dashboard/models/client.dart';
import 'package:dashboard/models/coach_travel_estimate.dart';
import 'package:dashboard/models/session.dart';
import 'package:flutter/material.dart';
import 'package:rrule/rrule.dart';

class Booking {
  final String id;
  final List<CoachTravelEstimate> coachTravelEstimates;
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
    required this.coachTravelEstimates,
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
          coachTravelEstimates: coachTravelEstimates,
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
          coachTravelEstimates: coachTravelEstimates,
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
      'coachTravelEstimates':
          coachTravelEstimates.map((e) => e.toJson()).toList(),
      'coachUids': coachTravelEstimates.map((e) => e.coach.uid).toList(),
      'activity': activity.toJson(),
      'initialActivityStart': initialActivityStart.toIso8601String(),
      'initialActivityEnd': initialActivityEnd.toIso8601String(),
      'initialArrival': initialArrival.toIso8601String(),
      'initialLeave': initialLeave.toIso8601String(),
      'recurrenceProperties': recurrenceRules?.toJson(),
      'client': client.toJson(),
    };
  }

  Map<String, dynamic> toFBJson() {
    return {
      'coachTravelEstimates': coachTravelEstimates,
      'activity': activity.toJson(),
      'startTime': initialActivityStart.toIso8601String(),
      'endTime': '${initialActivityEnd.hour}:${initialActivityEnd.minute}',
      'initialArrival': initialArrival.toIso8601String(),
      'initialLeave': initialLeave.toIso8601String(),
      'recurrenceProperties': recurrenceRules?.toJson(),
      'client': client.toJson(),
    };
  }

  factory Booking.fromQueryDocSnapshot(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final String id = doc.id;
    final List<CoachTravelEstimate> coachTravelEstimates =
        data['coachTravelEstimates']
            .map<CoachTravelEstimate>(
              (cte) => CoachTravelEstimate.fromJson(cte),
            )
            .toList();
    final Activity activity = Activity.fromJson(data['activity']);
    final DateTime initialActivityStart =
        DateTime.parse(data['initialActivityStart']);
    final DateTime initialActivityEnd =
        DateTime.parse(data['initialActivityEnd']);
    final DateTime initialArrival = DateTime.parse(data['initialArrival']);
    final DateTime initialLeave = DateTime.parse(data['initialLeave']);
    final Map<String, dynamic>? recurrenceRulesJson = data['recurrenceProperties'];
    final RecurrenceRule? recurrenceProperties = recurrenceRulesJson != null
        ? RecurrenceRule.fromJson(recurrenceRulesJson)
        : null;
    final Client client = Client.fromJson(data['client'], doc.id);
    return Booking(
      id: id,
      coachTravelEstimates: coachTravelEstimates,
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
    List<CoachTravelEstimate>? coachTravelEstimates,
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
      coachTravelEstimates: coachTravelEstimates ?? this.coachTravelEstimates,
      activity: activity ?? this.activity,
      initialActivityStart: initialActivityStart ?? this.initialActivityStart,
      initialActivityEnd: initialActivityEnd ?? this.initialActivityEnd,
      initialArrival: initialArrival ?? this.initialArrival,
      initialLeave: initialLeave ?? this.initialLeave,
      recurrenceRules: recurrenceRules ?? this.recurrenceRules,
      client: client ?? this.client,
    );
  }
}
