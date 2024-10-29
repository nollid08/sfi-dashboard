import 'package:dashboard/models/coach_calendar_source.dart';
import 'package:dashboard/providers/coach_calendar_source_provider.dart';
import 'package:dashboard/views/widgets/calendar.dart';
import 'package:dashboard/views/dialogs/request_annual_leave_dialog.dart';
import 'package:dashboard/views/widgets/wrappers/my_calendar_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyCalendar extends ConsumerWidget {
  const MyCalendar({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CoachCalendarSource source = ref.watch(coachCalendarSourceProvider);

    return MyCalendarWrapper(
      calendar: Calendar(
        coachCalendarSource: source,
      ),
      onAnnualLeaveRequested: () async {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return RequestAnnualLeaveDialog(
              coachUid: FirebaseAuth.instance.currentUser!.uid,
              onPop: () {
                source.invalidate();
              },
            );
          },
        );
      },
    );
  }
}
