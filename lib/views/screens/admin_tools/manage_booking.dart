import 'package:dashboard/models/booking.dart';
import 'package:dashboard/providers/single_booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageBooking extends ConsumerWidget {
  final bookingId;

  const ManageBooking(this.bookingId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Booking> booking =
        ref.watch(singleBookingProvider(bookingId));
    return booking.when(
      data: (Booking booking) {
        return Column(
          children: [
            Text(booking.client.name),
            Text(booking.activity.name),
            Text(booking.client.name),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}
