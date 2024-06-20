import 'package:dashboard/models/coach.dart';

class CoachTravelEstimate {
  final Coach coach;
  final double distance;
  final Duration duration;
  final DateTime leaveTime;

  CoachTravelEstimate({
    required this.coach,
    required this.distance,
    required this.duration,
    required this.leaveTime,
  });

  factory CoachTravelEstimate.fromJson(Map<String, dynamic> json) {
    return CoachTravelEstimate(
      coach: Coach.fromJson(json['coach']),
      distance: json['distance'],
      duration: Duration(seconds: json['duration']),
      leaveTime: DateTime.fromMillisecondsSinceEpoch(json['leaveTime']),
    );
  }
}
