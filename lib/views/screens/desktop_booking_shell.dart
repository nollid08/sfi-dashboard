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

class DesktopBookingShell extends ConsumerWidget {
  final Widget child;
  final String bookingId;
  final int? sessionIndex;

  const DesktopBookingShell({
    super.key,
    required this.child,
    required this.bookingId,
    required this.sessionIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isWideScreen =
        ref.watch(isWideScreenProvider(MediaQuery.of(context)));
    final AsyncValue<BookingWithSessions> bookingWithSessions =
        ref.watch(singleBookingWithSessionsProvider(bookingId));

    return bookingWithSessions.when(
      data: (BookingWithSessions bookingWithSessions) {
        return Scaffold(
          body: Swrap(
            padding: 8,
            child: Row(
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
                                  selected: sessionIndex == null,
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
                                    // if (kIsWeb) {
                                    //   context.go('/myBookings/$bookingId');
                                    // } else {
                                    context.push('/myBookings/$bookingId/');
                                    // }
                                  },
                                );
                              }

                              if (index ==
                                  bookingWithSessions.sessions.length + 1) {
                                return Container();
                              }
                              final Session session =
                                  bookingWithSessions.sessions[index - 1];
                              return ListTile(
                                leading: Text(
                                  (index).toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
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
                                  // if (kIsWeb) {
                                  //   context.go(
                                  //       '/myBookings/$bookingId/sessions/${index - 1}');
                                  // } else {
                                  context.push(
                                      '/myBookings/$bookingId/sessions/${index - 1}');
                                  // }
                                },
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: bookingWithSessions.sessions.length + 2,
                          ),
                        ),
                        const Divider(),
                      ],
                    )),
                if (isWideScreen) ...[
                  const VerticalDivider(),
                  Flexible(
                    flex: 3,
                    child: child,
                  )
                ]
              ],
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

class SmallScreenOnlyScaffold extends ConsumerWidget {
  const SmallScreenOnlyScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isWideScreen =
        ref.watch(isWideScreenProvider(MediaQuery.of(context)));
    if (!isWideScreen) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Booking'),
        ),
        body: child,
      );
    } else {
      return child;
    }
  }
}
