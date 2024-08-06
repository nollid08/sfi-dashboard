import 'package:dashboard/models/booking.dart';
import 'package:dashboard/providers/my_future_bookings.dart';
import 'package:dashboard/providers/my_past_bookings.dart';
import 'package:dashboard/views/screens/admin_tools/manual_booking/select_dates.dart';
import 'package:dashboard/views/widgets/wrappers/standard_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MyPastBookingsView extends ConsumerWidget {
  const MyPastBookingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Booking>> myPastBookings =
        ref.watch(myPastBookingsProvider);
    return Swrap(
      child: myPastBookings.when(
        data: (bookings) {
          if (bookings.isEmpty) {
            return const Center(
              child: Text('No past bookings'),
            );
          }
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.blue, width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  tileColor: Colors.blue[50],
                  title: Text(booking.activity.name),
                  subtitle: Text(
                      "${DateFormat("dd/MM/yyyy").format(booking.startDate)} - ${DateFormat("dd/MM/yyyy").format(booking.endDate)}"),
                  onTap: () {
                    context.go('/myBookings/${booking.id}');
                  },
                ),
              );
            },
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) {
          print(error);
          return Text('Error: $error, stack: $stackTrace');
        },
      ),
    );
  }
}
