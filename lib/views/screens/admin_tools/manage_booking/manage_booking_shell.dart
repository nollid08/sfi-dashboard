import 'package:dashboard/models/bookings_with_sessions.dart';
import 'package:dashboard/models/session.dart';
import 'package:dashboard/providers/booking_with_sessions_provider.dart';
import 'package:dashboard/providers/is_wide_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ManageBookingShell extends ConsumerWidget {
  final Widget child;
  final String bookingId;
  final bool isAddingNewSession;
  final int? sessionIndex;

  const ManageBookingShell({
    super.key,
    required this.child,
    required this.bookingId,
    required this.sessionIndex,
    this.isAddingNewSession = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isWideScreen =
        ref.watch(isWideScreenProvider(MediaQuery.of(context)));
    final AsyncValue<BookingWithSessions> bookingWithSessions =
        ref.watch(singleBookingWithSessionsProvider(bookingId));

    return bookingWithSessions.when(
      data: (BookingWithSessions bookingWithSessions) {
        return Row(
          children: [
            Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return ListTile(
                              selected:
                                  sessionIndex == null && !isAddingNewSession,
                              title: const Text('General Info'),
                              selectedColor: Colors.blue[800],
                              selectedTileColor: Colors.blue[50],
                              subtitle: Text(
                                '${bookingWithSessions.sessions.length} sessions',
                              ),
                              leading: const Icon(
                                Icons.star,
                                size: 20,
                              ),
                              onTap: () {
                                context.go(
                                    '/adminTools/manageBookings/$bookingId');
                              },
                            );
                          }
                          if (index ==
                              bookingWithSessions.sessions.length + 1) {
                            return ListTile(
                              title: const Text('Add New Session'),
                              selected: isAddingNewSession,
                              selectedColor: Colors.blue[800],
                              selectedTileColor: Colors.blue[50],
                              leading: const Icon(Icons.add),
                              onTap: () {
                                context.go(
                                    '/adminTools/manageBookings/$bookingId/addSession');
                              },
                            );
                          }
                          if (index ==
                              bookingWithSessions.sessions.length + 2) {
                            return Container();
                          }
                          final Session session =
                              bookingWithSessions.sessions[index - 1];
                          return ListTile(
                            leading: Text(
                              (index).toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            selected: sessionIndex == index - 1,
                            selectedColor: Colors.blue[800],
                            selectedTileColor: Colors.blue[50],
                            title: Text(
                              DateFormat.yMMMMEEEEd()
                                  .format(session.arrivalTime),
                            ),
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
                            onTap: () {
                              context.go(
                                  '/adminTools/manageBookings/$bookingId/sessions/${index - 1}');
                            },
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: bookingWithSessions.sessions.length + 3,
                      ),
                    ),
                    const Divider(),
                    //Back button

                    BackButton(
                      onPressed: () {
                        context.go('/adminTools/manageBookings');
                      },
                    ),
                  ],
                )),
            if (isWideScreen) ...[
              const VerticalDivider(),
              Flexible(
                flex: 3,
                child: child,
              ),
            ]
          ],
        );
      },
      loading: () => const Center(
          child: SizedBox.square(
              dimension: 100, child: CircularProgressIndicator())),
      error: (error, stackTrace) {
        return Text(' Error: $error, $stackTrace');
        // throw Exception(error);
      },
    );
  }
}
