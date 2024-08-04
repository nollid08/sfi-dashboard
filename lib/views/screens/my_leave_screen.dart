import 'package:dashboard/extensions.dart';
import 'package:dashboard/models/leave.dart';
import 'package:dashboard/providers/leaves_provider.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MyLeaveScreen extends ConsumerWidget {
  const MyLeaveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Leave>> myLeaves = ref
        .watch(leavesProvider([FirebaseAuth.instance.currentUser!.uid].lock));
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: myLeaves.when(
            data: (leaves) {
              return ListView.builder(
                itemCount: leaves.length,
                itemBuilder: (context, index) {
                  final leave = leaves[index];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(
                        "${DateFormat(
                          'HH:mm dd/MM/yy',
                        ).format(
                          leave.startDate,
                        )} - ${DateFormat(
                          'HH:mm dd/MM/yy',
                        ).format(
                          leave.endDate,
                        )}",
                      ),
                      textColor: leave.status == LeaveStatus.approved
                          ? Colors.white
                          : leave.status == LeaveStatus.rejected
                              ? Colors.white
                              : Colors.black,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
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
                                              : leave.status ==
                                                      LeaveStatus.rejected
                                                  ? 'Rejected'
                                                  : leave.status ==
                                                          LeaveStatus.completed
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
                          },
                        );
                      },
                      subtitle: Text(
                          leave.status.toString().split('.').last.capitalize()),
                      tileColor: leave.status == LeaveStatus.approved
                          ? Colors.green[500]
                          : leave.status == LeaveStatus.rejected
                              ? Colors.red[500]
                              : Colors.yellow[500],
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: leave.status == LeaveStatus.approved
                                ? Colors.green[700]!
                                : leave.status == LeaveStatus.rejected
                                    ? Colors.red[700]!
                                    : Colors.yellow[700]!,
                            width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) {
              throw error;
            },
          ),
        ),
      ),
    );
  }
}
