import 'package:dashboard/models/booking.dart';
import 'package:dashboard/providers/my_future_bookings.dart';
import 'package:dashboard/views/screens/admin_tools/manual_booking/select_dates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MyFutureBookingsView extends ConsumerWidget {
  const MyFutureBookingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Booking>> myFutureBookings =
        ref.watch(myFutureBookingsProvider);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: myFutureBookings.when(
          data: (bookings) {
            if (bookings.isEmpty) {
              return const Center(
                child: Text('No Future bookings'),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return ListTile(
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
                  );
                },
              ),
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stackTrace) {
            print(error);
            return Text('Error: $error, stack: $stackTrace');
          },
        ),
      ),
    );
  }
}
