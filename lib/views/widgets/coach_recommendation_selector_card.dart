import 'package:dashboard/models/coach.dart';
import 'package:dashboard/models/coach_recommendation.dart';
import 'package:dashboard/views/widgets/fortnightly_breakdown.dart';
import 'package:flutter/material.dart';

class CoachRecommenationSelectorCard extends StatelessWidget {
  const CoachRecommenationSelectorCard({
    super.key,
    required this.onCoachSelected,
    required this.coachRecommendation,
    required this.selectedCoaches,
    required this.coach,
    required this.departureTime,
  });

  final Function(CoachRecommendation p1) onCoachSelected;
  final CoachRecommendation coachRecommendation;
  final List<CoachRecommendation> selectedCoaches;
  final Coach coach;
  final DateTime departureTime;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onCoachSelected(coachRecommendation);
      },
      child: Card(
        color: selectedCoaches.contains(coachRecommendation)
            ? Colors.blue[50]
            : Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: selectedCoaches.contains(coachRecommendation)
                  ? Colors.blue
                  : Colors.white,
              width: 2.0),
          borderRadius: BorderRadius.circular(4.0),
        ),
        borderOnForeground: true,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        coach.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'Base Eircode: ${coach.baseEircode}',
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Distance: ${(coachRecommendation.travelEstimate.distance / 1000).round()} km',
                      ),
                      Text(
                        'Travel Time: ${coachRecommendation.travelEstimate.duration.inMinutes} minutes',
                      ),
                      Text('Leave Time: $departureTime'),
                      Text(
                          'Current Qouta Percentage Avg: ${(coachRecommendation.qoutaInfo.currentAverageQoutaPercentage * 100).floor()}%'),
                      Text(
                          'Projected Qouta Percentage Avg: ${(coachRecommendation.qoutaInfo.projectedQoutaPercentage * 100).floor()}%'),
                    ],
                  ),
                ],
              ),
              const Divider(),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Current FN Breakdown: ',
                      ),
                      FornightlyBreakdown(
                        fortnightlyQoutaPercentages: coachRecommendation
                            .qoutaInfo.currentFortnightlyQoutaPercentages,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Projected FN Breakdown: ',
                      ),
                      FornightlyBreakdown(
                        fortnightlyQoutaPercentages: coachRecommendation
                            .qoutaInfo.projectedFortnightlyQoutaPercentages,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
