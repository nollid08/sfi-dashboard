import 'package:dashboard/models/coach.dart';
import 'package:dashboard/models/coach_recommendation.dart';
import 'package:dashboard/views/widgets/coach_recommendation_selector_card.dart';
import 'package:dashboard/views/widgets/fortnightly_breakdown.dart';
import 'package:flutter/material.dart';

class CoachRecommenationSelector extends StatelessWidget {
  final List<CoachRecommendation> selectedCoaches;
  final List<CoachRecommendation> coachRecommendations;
  final Function(CoachRecommendation) onCoachSelected;
  final DateTime arrivalTime;

  const CoachRecommenationSelector({
    super.key,
    required this.selectedCoaches,
    required this.coachRecommendations,
    required this.onCoachSelected,
    required this.arrivalTime,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      itemBuilder: (context, index) {
        final CoachRecommendation coachRecommendation =
            coachRecommendations[index];
        final Coach coach = coachRecommendation.coach;
        final departureTime =
            arrivalTime.subtract(coachRecommendation.travelEstimate.duration);
        return CoachRecommenationSelectorCard(
            onCoachSelected: onCoachSelected,
            coachRecommendation: coachRecommendation,
            selectedCoaches: selectedCoaches,
            coach: coach,
            departureTime: departureTime);
      },
      itemCount: coachRecommendations.length,
    );
  }
}
