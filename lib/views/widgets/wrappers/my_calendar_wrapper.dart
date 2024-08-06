import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/providers/coach_calendar_source_provider.dart';
import 'package:dashboard/providers/is_wide_screen_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyCalendarWrapper extends ConsumerWidget {
  const MyCalendarWrapper(
      {super.key,
      required this.calendar,
      required this.onAnnualLeaveRequested});

  final Widget calendar;
  final Function() onAnnualLeaveRequested;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isWideScreen = ref.watch(
      isWideScreenProvider(
        MediaQuery.of(context),
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isWideScreen)
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: calendar,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FilledButton.icon(
                          onPressed: onAnnualLeaveRequested,
                          label: const Text('Request Annual Leave'),
                          icon: const Icon(Icons.beach_access),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (!isWideScreen)
          Expanded(
            child: Scaffold(
              body: calendar,
              floatingActionButton: FloatingActionButton(
                onPressed: onAnnualLeaveRequested,
                child: const Icon(Icons.beach_access),
              ),
            ),
          ),
        const CalendarRefresher(),
      ],
    );
  }
}

class CalendarRefresher extends ConsumerStatefulWidget {
  const CalendarRefresher({
    super.key,
  });

  @override
  ConsumerState<CalendarRefresher> createState() => _CalendarRefresherState();
}

class _CalendarRefresherState extends ConsumerState<CalendarRefresher> {
  bool initialLeaveLoadCompleted = false;
  bool initialBookingsLoadCompleted = false;
  bool initialSessionsLoadCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Visibility.maintain(
      visible: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('leaves')
                .where('coachUid',
                    isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (!initialLeaveLoadCompleted) {
                  initialLeaveLoadCompleted = true;
                  return Container();
                }
                ref.read(coachCalendarSourceProvider).invalidate();
              }
              return Container();
            },
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('leaves')
                .where('coachUid',
                    isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                refresh();
              }
              return Container();
            },
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('bookings')
                .where('coaches',
                    arrayContains: FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                refresh();
              }
              return Container();
            },
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('sessions')
                .where('coaches',
                    arrayContains: FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                refresh();
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  Future<void> refresh() async {
    await ref.read(coachCalendarSourceProvider).invalidate();
    ref.read(coachCalendarSourceProvider).invalidate();
  }
}
