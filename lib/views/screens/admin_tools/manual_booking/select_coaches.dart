import 'package:dashboard/models/assigned_coach.dart';
import 'package:dashboard/models/booking_template.dart';
import 'package:dashboard/models/coach.dart';
import 'package:dashboard/models/coach_recommendation.dart';
import 'package:dashboard/models/fortnightly_qouta_percentage.dart';
import 'package:dashboard/models/qouta_info.dart';
import 'package:dashboard/models/travel_estimate.dart';
import 'package:dashboard/models/travel_info.dart';
import 'package:dashboard/providers/bookings_provider.dart';
import 'package:dashboard/providers/find_coach.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

class SelectCoachesScreen extends ConsumerStatefulWidget {
  final BookingTemplate bookingTemplate;
  const SelectCoachesScreen(this.bookingTemplate, {super.key});

  @override
  ConsumerState<SelectCoachesScreen> createState() =>
      _SelectCoachesScreenState();
}

class _SelectCoachesScreenState extends ConsumerState<SelectCoachesScreen> {
  final List<CoachRecommendation> selectedCoaches = [];
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<CoachRecommendation>> suitableCoaches =
        ref.watch(findAvailableCoachesProvider(widget.bookingTemplate));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(children: [
                    const Text(
                      'Current Booking',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 30,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Activity: ${widget.bookingTemplate.activity.name}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Client: ${widget.bookingTemplate.client.name}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Sessions No.: ${widget.bookingTemplate.sessions.length}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ]),
                ),
                const VerticalDivider(),
                Expanded(
                  child: Column(
                    children: [
                      const Text('Select Coaches',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30)),
                      Expanded(
                        child: suitableCoaches.when(
                          data: (List<CoachRecommendation>
                                  coachRecommendations) =>
                              ListView.builder(
                            primary: false,
                            itemBuilder: (context, index) {
                              final CoachRecommendation coachRecommendation =
                                  coachRecommendations[index];
                              final Coach coach = coachRecommendation.coach;
                              final departureTime = widget
                                  .bookingTemplate.sessions[0].arrivalTime
                                  .subtract(coachRecommendation
                                      .travelEstimate.duration);
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCoaches
                                            .contains(coachRecommendation)
                                        ? selectedCoaches
                                            .remove(coachRecommendation)
                                        : selectedCoaches
                                            .add(coachRecommendation);
                                  });
                                },
                                child: Card(
                                  color: selectedCoaches
                                          .contains(coachRecommendation)
                                      ? Colors.blue[50]
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: selectedCoaches
                                                .contains(coachRecommendation)
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                                Text(
                                                    'Leave Time: $departureTime'),
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                const Text(
                                                  'Current FN Breakdown: ',
                                                ),
                                                FornightlyBreakdown(
                                                  fortnightlyQoutaPercentages:
                                                      coachRecommendation
                                                          .qoutaInfo
                                                          .currentFortnightlyQoutaPercentages,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                const Text(
                                                  'Projected FN Breakdown: ',
                                                ),
                                                FornightlyBreakdown(
                                                  fortnightlyQoutaPercentages:
                                                      coachRecommendation
                                                          .qoutaInfo
                                                          .projectedFortnightlyQoutaPercentages,
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
                            },
                            itemCount: coachRecommendations.length,
                          ),
                          loading: () => const CircularProgressIndicator(),
                          error: (error, stackTrace) {
                            return Center(
                              child: Column(
                                children: [
                                  const Text('Error loading coaches'),
                                  Text(error.toString()),
                                  Text(stackTrace.toString()),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: FloatingActionButton.extended(
                  disabledElevation: 0,
                  onPressed: selectedCoaches.isEmpty
                      ? null
                      : () async {
                          if (selectedCoaches.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please select at least one coach'),
                              ),
                            );
                            return;
                          }
                          final IList<Coach> param = <Coach>[].lock;
                          var bookingsProv =
                              ref.read(bookingsProvider(param).notifier);

                          final List<AssignedCoach> assignedCoaches =
                              selectedCoaches
                                  .map((sc) =>
                                      AssignedCoach.fromRecommendation(sc))
                                  .toList();
                          final BookingTemplate booking =
                              widget.bookingTemplate.copyWith(
                            assignedCoaches: assignedCoaches,
                          );
                          context.loaderOverlay.show();
                          await bookingsProv.addBooking(booking);
                          if (context.mounted) {
                            context.loaderOverlay.hide();

                            context.go(
                                '/adminTools/manageBookings/${booking.bookingId}');
                          }
                        },
                  label: (const Text('Submit Booking')),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class FornightlyBreakdown extends StatelessWidget {
  const FornightlyBreakdown({
    super.key,
    required this.fortnightlyQoutaPercentages,
  });
  final List<FortnightlyQoutaPercentage> fortnightlyQoutaPercentages;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        for (FortnightlyQoutaPercentage fortnightlyQoutaPercent
            in fortnightlyQoutaPercentages)
          FortnightBreakdown(fortnightlyQoutaPercent: fortnightlyQoutaPercent),
      ],
    );
  }
}

class FortnightBreakdown extends StatelessWidget {
  const FortnightBreakdown({
    super.key,
    required this.fortnightlyQoutaPercent,
  });

  final FortnightlyQoutaPercentage fortnightlyQoutaPercent;

  @override
  Widget build(BuildContext context) {
    final Color indicatorColor = fortnightlyQoutaPercent.qoutaPercentage > 1
        ? Colors.green
        : fortnightlyQoutaPercent.qoutaPercentage > 0.6
            ? Colors.yellow
            : fortnightlyQoutaPercent.qoutaPercentage > 0.3
                ? Colors.orange[400]!
                : fortnightlyQoutaPercent.qoutaPercentage > 0.2
                    ? Colors.orange[700]!
                    : Colors.red;

    return Card(
      surfaceTintColor: indicatorColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: indicatorColor,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Center(
          child: Column(
            children: [
              Text(
                'FN${fortnightlyQoutaPercent.fortnight.index}',
              ),
              Text(
                '${(fortnightlyQoutaPercent.qoutaPercentage * 100).floor()}%',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
