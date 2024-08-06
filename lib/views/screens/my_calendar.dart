import 'package:dashboard/models/coach.dart';
import 'package:dashboard/models/coach_calendar_source.dart';
import 'package:dashboard/views/widgets/calendar.dart';
import 'package:dashboard/views/widgets/request_annual_leave_dialog.dart';
import 'package:dashboard/views/widgets/wrappers/my_calendar_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MyCalendar extends ConsumerWidget {
  const MyCalendar({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CoachCalendarSource source = CoachCalendarSource(
      [],
      ref: ref,
      coachUid: FirebaseAuth.instance.currentUser!.uid,
    );
    // return Card(
    //   margin: const EdgeInsets.all(16),
    //   child: Column(
    //     children: [
    //       Expanded(
    //         child: Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Calendar(
    //             coachCalendarSource: source,
    //           ),
    //         ),
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //           children: [
    //             FilledButton.icon(
    //               onPressed: () async {
    //                 await showDialog(
    //                   context: context,
    //                   builder: (BuildContext context) {
    //                     return RequestAnnualLeaveDialog(
    //                       coachUid: FirebaseAuth.instance.currentUser!.uid,
    //                       onPop: () {
    //                         source.invalidate();
    //                       },
    //                     );
    //                   },
    //                 );
    //               },
    //               label: const Text('Request Annual Leave'),
    //               icon: const Icon(Icons.beach_access),
    //             ),
    //           ],
    //         ),
    //       )
    //     ],
    //   ),
    // );

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
