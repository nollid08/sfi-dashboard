import 'package:dashboard/models/booking.dart';
import 'package:dashboard/models/coach.dart';
import 'package:dashboard/providers/find_coach.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectCoachesScreen extends ConsumerWidget {
  final Booking booking;
  const SelectCoachesScreen(this.booking, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Coach>> helloWorld =
        ref.watch(findCoachesProvider(booking));
    final bool repeats = booking.recurrenceProperties != null;
    return Row(
      children: [
        Expanded(
          child: Column(children: [
            const Text('Current Booking'),
            Text('Activity: ${booking.activity.name}'),
            Text('Client: ${booking.client.name}'),
            Text('Initial Date: ${booking.startDateTime}'),
            Text(
              'Time: ${booking.startDateTime.hour}:${booking.startDateTime.minute} - ${booking.endTime.hour}:${booking.endTime.minute}',
            ),
            Text('Repeats?: $repeats'),
            if (repeats)
              Text('Recurrence Properties: ${booking.recurrenceProperties}'),
          ]),
        ),
        const VerticalDivider(),
        Expanded(
          child: helloWorld.when(
            data: (data) => ListView.builder(
              itemBuilder: (context, index) {
                final Coach coach = data[index];
                return ListTile(
                  title: Text(coach.name),
                  subtitle: Text(coach.baseEircode),
                  onTap: () {
                    // Do something with the coach
                  },
                );
              },
              itemCount: data.length,
            ),
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => Text('Error: $error'),
          ),
        ),
      ],
    );
  }
}
