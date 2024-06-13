import 'dart:js_interop';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:dashboard/models/activity.dart';
import 'package:dashboard/models/booking.dart';
import 'package:dashboard/models/coach.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'find_coach.g.dart';

@riverpod
Future<List<Coach>> findCoaches(FindCoachesRef ref, Booking booking) async {
  final functions = FirebaseFunctions.instance;
  final callable = functions.httpsCallable('find_coaches');
  final result = await callable.call({
    'booking': booking.toJson(),
  });

  print(result.data.toString());
  try {
    final data = List<Map<String, dynamic>>.from(result.data);
    final List<Coach> coaches = [];
    for (Map<String, dynamic> coachData in data) {
      Coach coach = Coach.fromJson(coachData);
      coaches.add(coach);
    }
    print(coaches);
    return coaches;
  } catch (e) {
    throw Exception('Error: $e');
  }
}
