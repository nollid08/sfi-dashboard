import 'package:dashboard/models/coach.dart';

class CoachSuitablity {
  final Coach coach;
  final double distance;
  final int minutesToTravel;
  final bool doesCoverActivity;

  CoachSuitablity({
    required this.coach,
    required this.distance,
    required this.minutesToTravel,
    required this.doesCoverActivity,
  });
}
