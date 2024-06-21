import 'package:cloud_functions/cloud_functions.dart';
import 'package:dashboard/models/booking.dart';
import 'package:dashboard/models/coach_travel_estimate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'find_coach.g.dart';

@riverpod
Future<List<CoachTravelEstimate>> findAvailableCoaches(
    FindAvailableCoachesRef ref, Booking booking) async {
  final functions = FirebaseFunctions.instance;
  final callable = functions.httpsCallable('find_coaches');
  final result = await callable.call({
    'booking': booking.toJson(),
  });

  try {
    final data = List<Map<String, dynamic>>.from(result.data);
    final List<CoachTravelEstimate> coaches = [];
    for (Map<String, dynamic> coachData in data) {
      CoachTravelEstimate coachTravelEstimate =
          CoachTravelEstimate.fromJson(coachData);
      coaches.add(coachTravelEstimate);
    }
    //Sort by duration
    coaches.sort((a, b) => a.duration.compareTo(b.duration));
    return coaches;
  } catch (e) {
    throw Exception('Error: $e');
  }
}
