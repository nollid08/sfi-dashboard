import 'package:dashboard/models/leave.dart';
import 'package:flutter/material.dart';

class LeaveDetailsDialog extends StatelessWidget {
  const LeaveDetailsDialog({
    super.key,
    required this.leave,
  });

  final Leave leave;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Leave Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Start Date'),
            subtitle: Text(leave.startDate.toString()),
            leading: const Icon(Icons.calendar_today),
          ),
          ListTile(
            title: const Text('End Date'),
            subtitle: Text(leave.endDate.toString()),
            leading: const Icon(Icons.calendar_today),
          ),
          ListTile(
            title: const Text('Leave Status'),
            subtitle: Text(
              leave.status == LeaveStatus.pending
                  ? 'Pending'
                  : leave.status == LeaveStatus.approved
                      ? 'Approved'
                      : leave.status == LeaveStatus.rejected
                          ? 'Rejected'
                          : leave.status == LeaveStatus.completed
                              ? 'Completed'
                              : 'Current',
            ),
            leading: const Icon(Icons.beach_access),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
