class TravelInfo {
  final double outwardDistance;
  final Duration outwardDuration;
  final double homewardDistance;
  final Duration homewardDuration;
  final String departureLocation;
  final String returnLocation;

  TravelInfo({
    required this.outwardDistance,
    required this.outwardDuration,
    required this.homewardDistance,
    required this.homewardDuration,
    required this.departureLocation,
    required this.returnLocation,
  });

  Map<String, dynamic> toJson() {
    return {
      'outwardDistance': outwardDistance,
      'outwardDuration': outwardDuration.inMilliseconds,
      'homewardDistance': homewardDistance,
      'homewardDuration': homewardDuration.inMilliseconds,
      'departureLocation': departureLocation,
      'returnLocation': returnLocation,
    };
  }

  factory TravelInfo.fromJson(Map<String, dynamic> json) {
    return TravelInfo(
      outwardDistance: json['outwardDistance'],
      outwardDuration: Duration(milliseconds: json['outwardDuration']),
      homewardDistance: json['homewardDistance'],
      homewardDuration: Duration(milliseconds: json['homewardDuration']),
      departureLocation: json['departureLocation'],
      returnLocation: json['returnLocation'],
    );
  }
}
