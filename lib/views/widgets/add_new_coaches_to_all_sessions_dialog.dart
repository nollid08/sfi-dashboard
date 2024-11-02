import 'package:dashboard/models/assigned_coach.dart';
import 'package:dashboard/models/coach_recommendation.dart';
import 'package:dashboard/models/session.dart';
import 'package:dashboard/providers/find_bookings_available_coaches.dart';
import 'package:dashboard/providers/sessions_provider.dart';
import 'package:dashboard/views/widgets/coach_recommendation_selector.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNewCoachesToAllSessionsDialog extends ConsumerStatefulWidget {
  const AddNewCoachesToAllSessionsDialog({
    super.key,
    required this.alreadyAssignedCoaches,
    required this.session,
  });

  final List<AssignedCoach> alreadyAssignedCoaches;
  final Session session;

  @override
  ConsumerState<AddNewCoachesToAllSessionsDialog> createState() =>
      _AddNewCoachesToBookingDialogState();
}

class _AddNewCoachesToBookingDialogState
    extends ConsumerState<AddNewCoachesToAllSessionsDialog> {
  final List<CoachRecommendation> selectedCoaches = [];
  @override
  Widget build(BuildContext context) {
    final suitableCoaches = ref
        .watch(findBookingsAvailableCoachesProvider(widget.session.bookingId));
    final bool actionsEnabled =
        selectedCoaches.isNotEmpty && suitableCoaches.hasValue;
    return AlertDialog(
      title: const Text(
        'Add New Coaches',
      ),
      surfaceTintColor: Colors.blue,
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 600,
          width: 800,
          child: suitableCoaches.when(
            data: (List<CoachRecommendation> provCoachRecommendations) {
              final List<CoachRecommendation> coachRecommendations =
                  provCoachRecommendations
                      .where((coachRecommendation) =>
                          !widget.alreadyAssignedCoaches.any((ac) =>
                              ac.coach.uid == coachRecommendation.coach.uid))
                      .toList();
              return CoachRecommenationSelector(
                selectedCoaches: selectedCoaches,
                coachRecommendations: coachRecommendations,
                activity: widget.session.activity,
                onCoachSelected: (CoachRecommendation selectedCoach) {
                  setState(() {
                    if (selectedCoaches.contains(selectedCoach)) {
                      selectedCoaches.remove(selectedCoach);
                    } else {
                      selectedCoaches.add(selectedCoach);
                    }
                  });
                },
                arrivalTime: widget.session.arrivalTime,
              );
            },
            loading: () => const Center(
              child: SizedBox.square(
                  dimension: 100, child: CircularProgressIndicator()),
            ),
            error: (error, _) => Text('Error: $error'),
          ),
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: actionsEnabled
              ? () {
                  final sessionsNotifier = ref.read(sessionsProvider(
                    bookingIds: [
                      widget.session.bookingId,
                    ].lock,
                  ).notifier);

                  sessionsNotifier.addCoachesToAllSessionsInBooking(
                    bookingId: widget.session.bookingId,
                    coachesRecommendationsToAdd: selectedCoaches,
                  );
                  Navigator.of(context).pop();
                }
              : null,
          child: Text(
            'Add ${selectedCoaches.length} Coaches To All Sessions',
          ),
        ),
      ],
    );
  }
}
