import 'package:dashboard/models/coach.dart';
import 'package:dashboard/models/qouta_info.dart';
import 'package:dashboard/models/travel_estimate.dart';

class CoachRecommendation {
  final Coach coach;
  final TravelEstimate travelEstimate;
  final QoutaInfo qoutaInfo;

  CoachRecommendation({
    required this.coach,
    required this.travelEstimate,
    required this.qoutaInfo,
  });

  factory CoachRecommendation.fromJson(Map<String, dynamic> jsonData) {
    final coach = Coach.fromJson(jsonData['coach']);
    final travelEstimate = TravelEstimate.fromJson(jsonData['travelEstimate']);
    final qoutaInfoMS = jsonData['qoutaInfo'];
    final qoutaInfoML = jsonData['qoutaInfo'];
    final qoutaInfo = QoutaInfo.fromJson(qoutaInfoMS);

    return CoachRecommendation(
      coach: Coach.fromJson(jsonData['coach']),
      travelEstimate: TravelEstimate.fromJson(jsonData['travelEstimate']),
      qoutaInfo: QoutaInfo.fromJson(jsonData['qoutaInfo']),
    );
  }
}
