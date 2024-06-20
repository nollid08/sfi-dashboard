import 'package:dashboard/models/booking.dart';
import 'package:dashboard/models/coach.dart';
import 'package:dashboard/models/coach_travel_estimate.dart';
import 'package:dashboard/providers/bookings_provider.dart';
import 'package:dashboard/providers/find_coach.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectCoachesScreen extends ConsumerStatefulWidget {
  final Booking booking;
  const SelectCoachesScreen(this.booking, {super.key});

  @override
  ConsumerState<SelectCoachesScreen> createState() =>
      _SelectCoachesScreenState();
}

class _SelectCoachesScreenState extends ConsumerState<SelectCoachesScreen> {
  final List<Coach> selectedCoaches = [];
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<CoachTravelEstimate>> suitableCoaches =
        ref.watch(findAvailableCoachesProvider(widget.booking));
    final bool repeats = widget.booking.recurrenceProperties != null;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(children: [
                    const Text('Current Booking'),
                    Text('Activity: ${widget.booking.activity.name}'),
                    Text('Client: ${widget.booking.client.name}'),
                    Text('Initial Date: ${widget.booking.startDateTime}'),
                    Text(
                      'Time: ${widget.booking.startDateTime.hour}:${widget.booking.startDateTime.minute} - ${widget.booking.endTime.hour}:${widget.booking.endTime.minute}',
                    ),
                    Text('Repeats?: $repeats'),
                    if (repeats)
                      Text(
                          'Recurrence Properties: ${widget.booking.recurrenceProperties}'),
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
                          data: (data) => ListView.builder(
                            itemBuilder: (context, index) {
                              final CoachTravelEstimate coachTravelEstimate =
                                  data[index];
                              final Coach coach = coachTravelEstimate.coach;
                              return Card(
                                color: selectedCoaches.contains(coach)
                                    ? Colors.blue[50]
                                    : Colors.white,
                                shape: selectedCoaches.contains(coach)
                                    ? RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: Colors.blue, width: 2.0),
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      )
                                    : RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: Colors.white, width: 2.0),
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                borderOnForeground: true,
                                child: ListTile(
                                  title: Text(coach.name),
                                  subtitle: Text(coach.baseEircode!),
                                  onTap: () {
                                    setState(() {
                                      selectedCoaches.contains(coach)
                                          ? selectedCoaches.remove(coach)
                                          : selectedCoaches.add(coach);
                                    });
                                  },
                                  trailing: Column(
                                    children: [
                                      Text(
                                          'Distance: ${(coachTravelEstimate.distance / 1000).round()} km'),
                                      Text(
                                          'Travel Time: ${coachTravelEstimate.duration.inMinutes} minutes'),
                                      Text(
                                          'Leave Time: ${coachTravelEstimate.leaveTime}'),
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: data.length,
                          ),
                          loading: () => const CircularProgressIndicator(),
                          error: (error, stackTrace) => Text('Error: $error'),
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
                      : () {
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
                          final Booking booking = widget.booking.copyWith(
                            coachIds: selectedCoaches
                                .map((coach) => coach.uid)
                                .toList(),
                          );
                          bookingsProv.addBooking(booking);
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
