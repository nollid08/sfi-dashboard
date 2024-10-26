import 'package:dashboard/models/booking.dart';
import 'package:dashboard/providers/is_wide_screen_provider.dart';
import 'package:dashboard/providers/my_future_bookings.dart';
import 'package:dashboard/providers/my_past_bookings.dart';
import 'package:dashboard/views/screens/admin_tools/manual_booking/select_dates.dart';
import 'package:dashboard/views/widgets/wrappers/standard_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MyBookingsView extends ConsumerWidget {
  const MyBookingsView({super.key, required this.bookingsToDisplay});

  final BookingsToDisplay bookingsToDisplay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isWideScreen = ref.watch(isWideScreenProvider(MediaQuery.of(context)));
    final AsyncValue<List<Booking>> myBookingsToDisplay =
        bookingsToDisplay == BookingsToDisplay.past
            ? ref.watch(myPastBookingsProvider)
            : ref.watch(myFutureBookingsProvider);
    return Swrap(
      child: myBookingsToDisplay.when(
        data: (bookings) {
          if (bookings.isEmpty) {
            return const Center(
              child: Text('No Future bookings'),
            );
          }
          return SizedBox.expand(
            child: ListView.builder(
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
                      if (isWideScreen) {
                        context.go('/myBookings/${booking.id}');
                      } else {
                        context.push('/myBookings/${booking.id}');
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) {
          return Text('Error: $error, stack: $stackTrace');
        },
      ),
    );
  }
}

enum BookingsToDisplay {
  future,
  past,
}
