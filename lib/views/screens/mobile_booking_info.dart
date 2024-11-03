import 'package:dashboard/models/bookings_with_sessions.dart';
import 'package:dashboard/models/session.dart';
import 'package:dashboard/providers/booking_with_sessions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';

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
          body: ListView.builder(
            itemBuilder: (context, index) {
              if (index == 0) {
                return ExpansionTile(
                    title: const Text('Booking Overview'),
                    backgroundColor: Colors.blue[50],
                    childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
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
                                      fontSize: 16),
                                ),
                              ),
                              const Divider(),
                              ListTile(
                                title: const Text("Activity:"),
                                trailing: Text(
                                    bookingWithSessions.activity.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
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
                                  'Client Info:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${bookingWithSessions.client.name},"),
                                    Text("${bookingWithSessions.client.town},"),
                                    Text(
                                        "${bookingWithSessions.client.county},"),
                                    Text(bookingWithSessions.client.eircode)
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.directions),
                                  onPressed: () {
                                    MapsLauncher.launchQuery(
                                      bookingWithSessions.client.eircode,
                                    );
                                  },
                                ),
                              ),
                              const Divider(),
                              ListTile(
                                title: const Text("Type:"),
                                trailing: Text(
                                    bookingWithSessions.client.type.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
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
                                          fontSize: 16)),
                                ),
                              ],
                              ListTile(
                                title: const Text("Client Students No.:"),
                                trailing: Text(
                                    bookingWithSessions.client.students
                                        .toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ),
                              if (bookingWithSessions.client.joinDate !=
                                  null) ...[
                                const Divider(),
                                ListTile(
                                  title: const Text("Client Join Date:"),
                                  trailing: Text(
                                      DateFormat("dd/MM/yy").format(
                                          bookingWithSessions.client.joinDate!),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                ),
                              ],
                              if (bookingWithSessions.client.contactName !=
                                  null) ...[
                                const Divider(),
                                ListTile(
                                  title: const Text("Contact Name:"),
                                  trailing: Text(
                                      bookingWithSessions.client.contactName!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                ),
                              ],
                              if (bookingWithSessions.client.contactPhone !=
                                  null) ...[
                                const Divider(),
                                ListTile(
                                  title: const Text("Contact Phone:"),
                                  trailing: Text(
                                      bookingWithSessions.client.contactPhone!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                ),
                              ],
                              if (bookingWithSessions.client.contactEmail !=
                                  null) ...[
                                const Divider(),
                                ListTile(
                                  title: const Text("Contact Email:"),
                                  trailing: Text(
                                      bookingWithSessions.client.contactEmail!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                ),
                              ],
                              if (bookingWithSessions.client.principalName !=
                                  null) ...[
                                const Divider(),
                                ListTile(
                                  title: const Text("Principal Name:"),
                                  trailing: Text(
                                      bookingWithSessions.client.principalName!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                ),
                              ],
                              if (bookingWithSessions.client.principalEmail !=
                                  null) ...[
                                const Divider(),
                                ListTile(
                                  title: const Text("Principal Email:"),
                                  trailing: Text(
                                      bookingWithSessions
                                          .client.principalEmail!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                ),
                              ],
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
                  Card(
                    color: Colors.grey[50],
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text("Arrival Time:"),
                          trailing: Text(
                              DateFormat("dd/MM/yy hh:mm")
                                  .format(session.arrivalTime),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text("Start Time:"),
                          trailing: Text(
                              DateFormat("dd/MM/yy hh:mm")
                                  .format(session.startTime),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text("End Time:"),
                          trailing: Text(
                              DateFormat("dd/MM/yy hh:mm")
                                  .format(session.endTime),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text("Leave Time:"),
                          trailing: Text(
                              DateFormat("dd/MM/yy hh:mm")
                                  .format(session.leaveTime),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        if (session.notes != null) ...[
                          const Divider(),
                          ListTile(
                            title: const Text("Notes:"),
                            subtitle: Text(session.notes!),
                          ),
                        ],
                      ],
                    ),
                  )
                ],
              );
            },
            itemCount: bookingWithSessions.sessions.length + 1,
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
