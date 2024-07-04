import 'package:dashboard/models/booking.dart';
import 'package:dashboard/models/coach.dart';
import 'package:dashboard/providers/bookings_provider.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ManageBookings extends ConsumerWidget {
  const ManageBookings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Booking>> bookings =
        ref.watch(bookingsProvider(<Coach>[].lock));
    return bookings.when(
      data: (List<Booking> bookings) {
        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final Booking booking = bookings[index];
            return ListTile(
              title: Text("${booking.client.name} - ${booking.activity.name}"),
              subtitle: Text(booking.client.name),
              onTap: () {
                context.go('/adminTools/manageBookings/${booking.id}');
              },
            );
          },
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error: $error, $stackTrace'),
    );
  }
}
