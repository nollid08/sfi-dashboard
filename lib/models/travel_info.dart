class TravelInfo {
  final double distance;
  final Duration duration;
  final String departureLocation;
  final String returnLocation;

  TravelInfo({
    required this.distance,
    required this.duration,
    required this.departureLocation,
    required this.returnLocation,
  });

  Map<String, dynamic> toJson() {
    return {
      'distance': distance,
      'duration': duration.inMilliseconds,
      'departureLocation': departureLocation,
      'returnLocation': returnLocation,
    };
  }

  factory TravelInfo.fromJson(Map<String, dynamic> json) {
    return TravelInfo(
      distance: json['distance'],
      duration: Duration(milliseconds: json['duration']),
      departureLocation: json['departureLocation'],
      returnLocation: json['returnLocation'],
    );
  }
}
