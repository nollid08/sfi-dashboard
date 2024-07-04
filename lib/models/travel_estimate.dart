import 'package:dashboard/models/coach.dart';

class TravelEstimate {
  final double distance;
  final Duration duration;

  TravelEstimate({
    required this.distance,
    required this.duration,
  });

  factory TravelEstimate.fromJson(Map<String, dynamic> json) {
    return TravelEstimate(
      distance: json['distance'],
      duration: Duration(milliseconds: json['duration']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'distance': distance,
      'duration': duration.inMilliseconds,
    };
  }
}
