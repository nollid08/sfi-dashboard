import 'package:dashboard/models/session.dart';
import 'package:dashboard/models/travel_info.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';

class SessionInfoDialog extends StatelessWidget {
  const SessionInfoDialog({
    super.key,
    required this.session,
    required this.sessionIndex,
    required this.travelInfo,
  });

  final Session session;
  final int sessionIndex;
  final TravelInfo travelInfo;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("${session.activity.name} - ${session.client.name}"),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.directions_car),
              title: Text(
                  'Leave Home By: ${DateFormat("hh:mm dd/MM/yy").format(session.arrivalTime.subtract(travelInfo.duration))}'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: Text(
                  'Arrival Time: ${DateFormat("hh:mm dd/MM/yy").format(session.arrivalTime)}'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: Text(
                  'Start Time: ${DateFormat("hh:mm dd/MM/yy").format(session.startTime)}'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: Text(
                  'End Time: ${DateFormat("hh:mm dd/MM/yy").format(session.endTime)}'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: Text(
                  'Leave Time: ${DateFormat("hh:mm dd/MM/yy").format(session.leaveTime)}'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(
                  'Location: ${session.client.eircode}, ${session.client.town}, ${session.client.county}'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.people),
              title: Text(
                'Coaches: ${session.assignedCoaches.map((ac) {
                  return ac.coach.name;
                }).join(', ')}',
              ),
            ),
            const Divider(),
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () {
            MapsLauncher.launchQuery(
              session.client.eircode,
            );
          },
          child: const Text('Take Me There!'),
        ),
        FilledButton(
          onPressed: () {
            final String url =
                '/myBookings/${session.bookingId}/sessions/$sessionIndex';
            context.push(url);
            Navigator.of(context).pop();
          },
          child: const Text('View Session'),
        ),
        FilledButton(
          onPressed: () {
            final String url = '/myBookings/${session.bookingId}';
            context.push(url);
            Navigator.of(context).pop();
          },
          child: const Text('View Booking'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
