import 'package:dashboard/models/coach.dart';

class CoachTravelEstimate {
  final Coach coach;
  final double distance;
  final Duration duration;

  CoachTravelEstimate({
    required this.coach,
    required this.distance,
    required this.duration,
  });

  factory CoachTravelEstimate.fromJson(Map<String, dynamic> json) {
    return CoachTravelEstimate(
      coach: Coach.fromJson(json['coach']),
      distance: json['distance'],
      duration: Duration(seconds: json['duration']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coach': coach.toJson(),
      'distance': distance,
      'duration': duration.inSeconds,
    };
  }
}
