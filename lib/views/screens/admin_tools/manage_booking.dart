import 'package:dashboard/models/booking.dart';
import 'package:dashboard/models/bookings_with_sessions.dart';
import 'package:dashboard/providers/booking_with_sessions_provider.dart';
import 'package:dashboard/providers/single_booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageBooking extends ConsumerWidget {
  final bookingId;

  const ManageBooking(this.bookingId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<BookingWithSessions> bookingWithSessions =
        ref.watch(singleBookingWithSessionsProvider(bookingId));

    return bookingWithSessions.when(
      data: (BookingWithSessions bookingWithSessions) {
        return Column(
          children: [
            Text('Booking ID: ${bookingWithSessions.id}'),
            Text('Client: ${bookingWithSessions.client.name}'),
            Text('Activity: ${bookingWithSessions.activity.name}'),
            Text('Coaches: ${bookingWithSessions.coachesUids}'),
            Text('Sessions: ${bookingWithSessions.sessions}'),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) =>
          Text('Error: $error, StackTrace: $stackTrace'),
    );
  }
}
