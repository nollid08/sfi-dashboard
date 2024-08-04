import 'package:dashboard/models/bookings_with_sessions.dart';
import 'package:dashboard/providers/booking_with_sessions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ViewBooking extends ConsumerWidget {
  final String id;

  const ViewBooking({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<BookingWithSessions> bookingWithSessions =
        ref.watch(singleBookingWithSessionsProvider(id));

    return bookingWithSessions.when(
      data: (BookingWithSessions bookingWithSessions) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text('View Booking with id: $id'),
              Card(
                child: Column(
                  children: [
                    const Text(
                      'Client Info',
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          const TextSpan(
                              text: 'Name: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: bookingWithSessions.client.name),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          const TextSpan(
                              text: 'Town: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: bookingWithSessions.client.town),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          const TextSpan(
                              text: 'County: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: bookingWithSessions.client.county),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          const TextSpan(
                              text: 'Town: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: bookingWithSessions.client.eircode),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          const TextSpan(
                              text: 'Type: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: bookingWithSessions.client.type.name),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          const TextSpan(
                              text: 'Classrooms: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: bookingWithSessions.client.classrooms
                                  .toString()),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          const TextSpan(
                              text: 'Students: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: bookingWithSessions.client.students
                                  .toString()),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          const TextSpan(
                              text: 'Town: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: bookingWithSessions.client.town),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          const TextSpan(
                              text: 'Join Date: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: DateFormat("dd//MM//yy").format(
                                  bookingWithSessions.client.joinDate ??
                                      DateTime.now())),
                        ],
                      ),
                    ),
                    bookingWithSessions.client.contactName != null
                        ? RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: 'Contact Name: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: bookingWithSessions
                                        .client.contactName!),
                              ],
                            ),
                          )
                        : Container(),
                    bookingWithSessions.client.contactPhone != null
                        ? RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: 'Contact Phone: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: bookingWithSessions
                                        .client.contactPhone!),
                              ],
                            ),
                          )
                        : Container(),
                    bookingWithSessions.client.contactEmail != null
                        ? RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: 'Contact Email: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: bookingWithSessions
                                        .client.contactEmail!),
                              ],
                            ),
                          )
                        : Container(),
                    bookingWithSessions.client.largestClassSize != null
                        ? RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: 'Largest Class Size: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: bookingWithSessions
                                        .client.largestClassSize
                                        .toString()),
                              ],
                            ),
                          )
                        : Container(),
                    bookingWithSessions.client.principalName != null
                        ? RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: 'Principal Name: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: bookingWithSessions
                                        .client.principalName!),
                              ],
                            ),
                          )
                        : Container(),
                    bookingWithSessions.client.principalEmail != null
                        ? RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: 'Principal Phone: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: bookingWithSessions
                                        .client.principalEmail!),
                              ],
                            ),
                          )
                        : Container(),
                    bookingWithSessions.client.hasHall != null
                        ? RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: 'Has Hall: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: bookingWithSessions.client.hasHall
                                        .toString()),
                              ],
                            ),
                          )
                        : Container(),
                    bookingWithSessions.client.hasParking != null
                        ? RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: 'Has Parking: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: bookingWithSessions.client.hasParking
                                        .toString()),
                              ],
                            ),
                          )
                        : Container(),
                    bookingWithSessions.client.hasMats != null
                        ? RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: 'Has Mats: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: bookingWithSessions.client.hasParking
                                        .toString()),
                              ],
                            ),
                          )
                        : Container(),
                    bookingWithSessions.client.notes != null
                        ? RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: 'Client Notes: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: bookingWithSessions.client.notes!
                                        .toString()),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      const Text("Booking Info"),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'No. Of Sessions: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: bookingWithSessions.sessions.length
                                    .toString()),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'Activity: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: bookingWithSessions.activity.name),
                          ],
                        ),
                      ),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Booking Notes: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            // TextSpan(
                            //     text: bookingWithSessions.notes ?? ''),
                            TextSpan(text: 'No notes'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }
}
