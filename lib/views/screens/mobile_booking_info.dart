import 'package:dashboard/models/bookings_with_sessions.dart';
import 'package:dashboard/models/session.dart';
import 'package:dashboard/providers/booking_with_sessions_provider.dart';
import 'package:dashboard/providers/is_wide_screen_provider.dart';
import 'package:dashboard/views/widgets/wrappers/standard_wrapper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MobileBookingOverview extends ConsumerWidget {
  final String bookingId;

  const MobileBookingOverview({
    super.key,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<BookingWithSessions> bookingWithSessions =
        ref.watch(singleBookingWithSessionsProvider(bookingId));

    return bookingWithSessions.when(
      data: (BookingWithSessions bookingWithSessions) {
        return Scaffold(
          appBar: AppBar(
            title: Text(bookingWithSessions.activity.name),
            backgroundColor: Colors.blue[300],
          ),
          body: Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ExpansionTile(
                      title: const Text('Booking Overview'),
                      backgroundColor: Colors.blue[50],
                      childrenPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      children: [
                        Card(
                            color: Colors.grey[50],
                            child: Column(
                              children: [
                                ListTile(
                                  title: const Text("No. Of Sessions:"),
                                  trailing: Text(
                                    bookingWithSessions.sessions.length
                                        .toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                const Divider(),
                                ListTile(
                                  title: const Text("Activity:"),
                                  trailing: Text(
                                      bookingWithSessions.activity.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ),
                                const Divider(),
                                const ListTile(
                                  title: Text("Booking Notes:"),
                                  subtitle: Text(
                                    "No notes",
                                  ),
                                ),
                                const Divider(),
                                ListTile(
                                  title: const Text(
                                    'Client:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "${bookingWithSessions.client.name},"),
                                      Text(
                                          "${bookingWithSessions.client.town},"),
                                      Text(
                                          "${bookingWithSessions.client.county},"),
                                      Text(bookingWithSessions.client.eircode)
                                    ],
                                  ),
                                ),
                                if (bookingWithSessions.client.classrooms !=
                                    null) ...[
                                  const Divider(),
                                  ListTile(
                                    title: const Text("Client Classroom No.:"),
                                    trailing: Text(
                                        bookingWithSessions.client.classrooms
                                            .toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                  ),
                                ],
                                ListTile(
                                  title: const Text("Client Students No.:"),
                                  trailing: Text(
                                      bookingWithSessions.client.students
                                          .toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ),
                                ListTile(
                                  title: const Text("Client Join Date:"),
                                  trailing: Text(
                                      DateFormat("dd/MM/yy").format(
                                        bookingWithSessions.client.joinDate ??
                                            DateTime.now(),
                                      ),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ),
                              ],
                            )),
                      ]);
                }

                final Session session = bookingWithSessions.sessions[index - 1];
                return ExpansionTile(
                  leading: Text(
                    (index).toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  title: Text(
                    DateFormat.yMMMMEEEEd().format(session.arrivalTime),
                  ),
                  backgroundColor: Colors.blue[50],
                  subtitle: session.assignedCoaches.isNotEmpty
                      ? Text(session.assignedCoaches
                          .map((ac) => ac.coach.name)
                          .join(', '))
                      : const Text(
                          '!NO COACH ASSIGNED!',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                  children: [
                    Text('Session Type: ${session.arrivalTime}'),
                  ],
                );
              },
              itemCount: bookingWithSessions.sessions.length + 1,
            ),
          ),
        );
      },
      loading: () => const Center(
          child: SizedBox.square(
              dimension: 100, child: CircularProgressIndicator())),
      error: (error, stackTrace) {
        print("Error: $error, stack: $stackTrace");
        throw Exception(error);
      },
    );
  }
}
