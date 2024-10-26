import 'package:dashboard/models/assigned_coach.dart';
import 'package:dashboard/models/booking_template.dart';
import 'package:dashboard/models/coach.dart';
import 'package:dashboard/models/coach_recommendation.dart';
import 'package:dashboard/providers/bookings_provider.dart';
import 'package:dashboard/providers/find_booking_templates_available_coaches.dart';
import 'package:dashboard/views/widgets/booking_template_info.dart';
import 'package:dashboard/views/widgets/coach_recommendation_selector.dart';
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
    final AsyncValue<List<CoachRecommendation>> suitableCoaches = ref.watch(
        findBookingTemplatesAvailableCoachesProvider(widget.bookingTemplate));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: BookingTemplateInfo(
                    bookingTemplate: widget.bookingTemplate,
                  ),
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
                              CoachRecommenationSelector(
                            selectedCoaches: selectedCoaches,
                            coachRecommendations: coachRecommendations,
                            onCoachSelected: (CoachRecommendation coach) {
                              setState(() {
                                if (selectedCoaches.contains(coach)) {
                                  selectedCoaches.remove(coach);
                                } else {
                                  selectedCoaches.add(coach);
                                }
                              });
                            },
                            arrivalTime: widget
                                .bookingTemplate.sessions.first.arrivalTime,
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
