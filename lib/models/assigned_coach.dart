import 'package:dashboard/models/coach.dart';
import 'package:dashboard/models/coach_recommendation.dart';
import 'package:dashboard/models/travel_info.dart';

class AssignedCoach {
  final Coach coach;
  final TravelInfo travelInfo;
  final bool hasOvernightAllowance;

  AssignedCoach({
    required this.coach,
    required this.travelInfo,
    required this.hasOvernightAllowance,
  });

  Map<String, dynamic> toJson() {
    return {
      'coach': coach.toJson(),
      'travelInfo': travelInfo.toJson(),
      'hasOvernightAllowance': hasOvernightAllowance,
    };
  }

  factory AssignedCoach.fromJson(Map<String, dynamic> json) {
    return AssignedCoach(
      coach: Coach.fromFBJson(json['coach']),
      travelInfo: TravelInfo.fromJson(json['travelInfo']),
      hasOvernightAllowance: json['hasOvernightAllowance'],
    );
  }

  factory AssignedCoach.fromRecommendation(
      CoachRecommendation coachRecommendation) {
    final bool hasOvernightAllowance =
        coachRecommendation.travelEstimate.duration.inMilliseconds >=
            (3600000 * 4);

    return AssignedCoach(
      coach: coachRecommendation.coach,
      travelInfo: TravelInfo(
        outwardDistance: coachRecommendation.travelEstimate.distance,
        outwardDuration: coachRecommendation.travelEstimate.duration,
        homewardDistance: coachRecommendation.travelEstimate.distance,
        homewardDuration: coachRecommendation.travelEstimate.duration,
        departureLocation: coachRecommendation.coach.baseEircode ?? 'Unknown',
        returnLocation: coachRecommendation.coach.baseEircode ?? 'Unknown',
      ),
      hasOvernightAllowance: hasOvernightAllowance,
    );
  }
}
