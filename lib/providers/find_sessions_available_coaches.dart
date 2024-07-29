import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dashboard/models/booking.dart';
import 'package:dashboard/models/booking_template.dart';
import 'package:dashboard/models/coach_recommendation.dart';
import 'package:dashboard/models/session.dart';
import 'package:dashboard/models/travel_estimate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'find_sessions_available_coaches.g.dart';

@riverpod
Future<List<CoachRecommendation>> findSessionsAvailableCoaches(
    FindSessionsAvailableCoachesRef ref, Session session) async {
  final db = FirebaseFirestore.instance;

  final functions = FirebaseFunctions.instance;
  final callable = functions.httpsCallable('find_sessions_available_coaches');
  final result = await callable.call({
    'session': session.toJson(),
  });

  final data = List<Map<String, dynamic>>.from(result.data);
  final List<CoachRecommendation> coachRecommendations = [];
  for (Map<String, dynamic> recData in data) {
    CoachRecommendation coachRecommendation =
        CoachRecommendation.fromJson(recData);
    coachRecommendations.add(coachRecommendation);
  }
  coachRecommendations.sort((a, b) {
    return a.qoutaInfo.currentAverageQoutaPercentage
        .compareTo(b.qoutaInfo.currentAverageQoutaPercentage);
  });
  return coachRecommendations;
}
