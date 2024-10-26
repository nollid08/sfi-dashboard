import 'package:dashboard/models/bookings_with_sessions.dart';
import 'package:dashboard/providers/booking_with_sessions_provider.dart';
import 'package:dashboard/views/widgets/wrappers/standard_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ViewBookingInfo extends ConsumerWidget {
  final String id;

  const ViewBookingInfo({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<BookingWithSessions> bookingWithSessions =
        ref.watch(singleBookingWithSessionsProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Viewing Booking'),
        backgroundColor: Colors.blue[600],
      ),
      body: bookingWithSessions.when(
        data: (BookingWithSessions bookingWithSessions) {
          var children = [
            const Text(
              'Booking Info',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text("No. Of Sessions:"),
              trailing: Text(
                bookingWithSessions.sessions.length.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text("Activity:"),
              trailing: Text(bookingWithSessions.activity.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            const Divider(),
            const ListTile(
              title: Text("Booking Notes:"),
              subtitle: Text(
                "No notes",
              ),
            ),
            const Divider(
              thickness: 2,
            ),
            const Text(
              'Client Info',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            ListTile(
              title: const Text(
                'Name:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(bookingWithSessions.client.name),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Town:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(bookingWithSessions.client.town),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'County:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(bookingWithSessions.client.county),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Town:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(bookingWithSessions.client.eircode),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Type:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(bookingWithSessions.client.type.name),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Classrooms:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(bookingWithSessions.client.classrooms.toString()),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Students:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(bookingWithSessions.client.students.toString()),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Town:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(bookingWithSessions.client.town),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Join Date:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                DateFormat("dd/MM/yy").format(
                  bookingWithSessions.client.joinDate ?? DateTime.now(),
                ),
              ),
            ),
            const Divider(),
            bookingWithSessions.client.contactName != null
                ? Column(
                    children: [
                      ListTile(
                        title: const Text(
                          'Contact Name:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(bookingWithSessions.client.contactName!),
                      ),
                      const Divider(),
                    ],
                  )
                : Container(),
            bookingWithSessions.client.contactPhone != null
                ? Column(
                    children: [
                      ListTile(
                        title: const Text(
                          'Contact Phone:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle:
                            Text(bookingWithSessions.client.contactPhone!),
                      ),
                      const Divider(),
                    ],
                  )
                : Container(),
            bookingWithSessions.client.contactEmail != null
                ? Column(
                    children: [
                      ListTile(
                        title: const Text(
                          'Contact Email:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle:
                            Text(bookingWithSessions.client.contactEmail!),
                      ),
                      const Divider(),
                    ],
                  )
                : Container(),
            bookingWithSessions.client.largestClassSize != null
                ? Column(
                    children: [
                      ListTile(
                        title: const Text(
                          'Largest Class Size:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          bookingWithSessions.client.largestClassSize
                              .toString(),
                        ),
                      ),
                      const Divider(),
                    ],
                  )
                : Container(),
            bookingWithSessions.client.principalName != null
                ? Column(
                    children: [
                      ListTile(
                        title: const Text(
                          'Principal Name:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle:
                            Text(bookingWithSessions.client.principalName!),
                      ),
                      const Divider(),
                    ],
                  )
                : Container(),
            bookingWithSessions.client.principalEmail != null
                ? Column(
                    children: [
                      ListTile(
                        title: const Text(
                          'Principal Phone:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle:
                            Text(bookingWithSessions.client.principalEmail!),
                      ),
                      const Divider(),
                    ],
                  )
                : Container(),
            bookingWithSessions.client.hasHall != null
                ? Column(
                    children: [
                      ListTile(
                        title: const Text(
                          'Has Hall:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle:
                            Text(bookingWithSessions.client.hasHall.toString()),
                      ),
                      const Divider(),
                    ],
                  )
                : Container(),
            bookingWithSessions.client.hasParking != null
                ? Column(
                    children: [
                      ListTile(
                        title: const Text(
                          'Has Parking:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            bookingWithSessions.client.hasParking.toString()),
                      ),
                      const Divider(),
                    ],
                  )
                : Container(),
            bookingWithSessions.client.hasMats != null
                ? Column(
                    children: [
                      ListTile(
                        title: const Text(
                          'Has Mats:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle:
                            Text(bookingWithSessions.client.hasMats.toString()),
                      ),
                      const Divider(),
                    ],
                  )
                : Container(),
            bookingWithSessions.client.notes != null
                ? Column(
                    children: [
                      ListTile(
                        title: const Text(
                          'Client Notes:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle:
                            Text(bookingWithSessions.client.notes.toString()),
                      ),
                      const Divider(),
                    ],
                  )
                : Container(),
          ];
          return SingleChildScrollView(
            child: Swrap(
              child: Column(
                children: children,
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Text('Error: $error'),
      ),
    );
  }
}
