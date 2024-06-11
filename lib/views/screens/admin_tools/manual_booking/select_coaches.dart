import 'package:dashboard/models/booking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectCoachesScreen extends ConsumerWidget {
  final Booking booking;
  const SelectCoachesScreen(this.booking, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool repeats = booking.recurrenceProperties != null;
    return Row(
      children: [
        Expanded(
          child: Column(children: [
            Text('Current Booking'),
            Text('Activity: ${booking.activityId}'),
            Text('Initial Date: ${booking.startDateTime}'),
            Text(
              'Time: ${booking.startDateTime.hour}:${booking.startDateTime.minute} - ${booking.endTime.hour}:${booking.endTime.minute}',
            ),
            Text('Repeats?: $repeats'),
            if (repeats)
              Text('Recurrence Properties: ${booking.recurrenceProperties}'),
          ]),
        ),
        VerticalDivider(),
        Expanded(
          child: ListView(),
        ),
      ],
    );
  }
}
