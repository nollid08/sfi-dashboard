import 'package:dashboard/models/coach_linked_leave.dart';
import 'package:dashboard/models/leave.dart';
import 'package:dashboard/models/leaves_data_source.dart';
import 'package:dashboard/providers/coach_linked_leaves_provider.dart';
import 'package:dashboard/views/dialogs/admin_choose_coach.dart';
import 'package:dashboard/views/dialogs/request_annual_leave_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ManageLeaveRequests extends ConsumerWidget {
  const ManageLeaveRequests({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<CoachLinkedLeave>> coachLinkedLeaves =
        ref.watch(coachLinkedLeavesProvider);
    return coachLinkedLeaves.when(
      data: (List<CoachLinkedLeave> coachLinkedLeaves) {
        if (coachLinkedLeaves.isEmpty) {
          return const Center(
            child: Text('No leave requests'),
          );
        }
        var leavesDataSource = LeavesDataSource(
          coachLinkedLeaves: coachLinkedLeaves,
        );
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AdminChooseCoach();
                },
              );
            },
            child: const Icon(Icons.add),
          ),
          body: SfDataGrid(
            source: leavesDataSource,
            columnWidthMode: ColumnWidthMode.fill,
            headerRowHeight: 80,
            headerGridLinesVisibility: GridLinesVisibility.both,
            gridLinesVisibility: GridLinesVisibility.both,
            allowFiltering: true,
            allowSorting: true,
            allowEditing: true,
            selectionMode: SelectionMode.multiple,
            navigationMode: GridNavigationMode.row,
            allowColumnsResizing: true,
            onCellTap: (details) {
              final int selectedRowIndex = details.rowColumnIndex.rowIndex - 1;
              final DataGridRow row =
                  leavesDataSource.effectiveRows.elementAt(selectedRowIndex);
              final CoachLinkedLeave coachLinkedLeave =
                  row.getCells().last.value;
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Client Details'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('Coach Name'),
                          subtitle: Text(coachLinkedLeave.coach.name),
                          leading: const Icon(Icons.person),
                        ),
                        ListTile(
                          title: const Text('Start Date'),
                          subtitle: Text(coachLinkedLeave.startDate.toString()),
                          leading: const Icon(Icons.calendar_today),
                        ),
                        ListTile(
                          title: const Text('End Date'),
                          subtitle: Text(coachLinkedLeave.endDate.toString()),
                          leading: const Icon(Icons.calendar_today),
                        ),
                        ListTile(
                          title: const Text('Leave Type'),
                          subtitle: Text(coachLinkedLeave.type.toString()),
                          leading: const Icon(Icons.beach_access),
                        ),
                        ListTile(
                          title: const Text('Status'),
                          subtitle: Text(coachLinkedLeave.status.toString()),
                          leading: const Icon(Icons.info),
                        ),
                      ],
                    ),
                    actions: [
                      FilledButton.icon(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            coachLinkedLeave.status == LeaveStatus.pending ||
                                    coachLinkedLeave.status ==
                                        LeaveStatus.rejected
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),
                        onPressed: coachLinkedLeave.status ==
                                    LeaveStatus.pending ||
                                coachLinkedLeave.status == LeaveStatus.rejected
                            ? () {
                                ref
                                    .read(coachLinkedLeavesProvider.notifier)
                                    .approveLeave(coachLinkedLeave);
                                Navigator.pop(context);
                              }
                            : null,
                        label: const Text('Approve'),
                        icon: const Icon(Icons.check),
                      ),
                      FilledButton.icon(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            coachLinkedLeave.status == LeaveStatus.pending ||
                                    coachLinkedLeave.status ==
                                        LeaveStatus.approved
                                ? Colors.red
                                : Colors.grey,
                          ),
                        ),
                        onPressed: coachLinkedLeave.status ==
                                    LeaveStatus.pending ||
                                coachLinkedLeave.status == LeaveStatus.approved
                            ? () {
                                ref
                                    .read(coachLinkedLeavesProvider.notifier)
                                    .rejectLeave(coachLinkedLeave);
                                Navigator.pop(context);
                              }
                            : null,
                        label: const Text('Reject'),
                        icon: const Icon(Icons.close),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
            columns: [
              GridColumn(
                columnName: 'CoachName',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: const Text('Coach Name'),
                ),
              ),
              GridColumn(
                columnName: 'StartDate',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: const Text('Start Date'),
                ),
              ),
              GridColumn(
                columnName: 'EndDate',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: const Text('End Date'),
                ),
              ),
              GridColumn(
                columnName: 'LeaveType',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: const Text('Leave Type'),
                ),
              ),
              GridColumn(
                columnName: 'Status',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: const Text('Status'),
                ),
              ),
              GridColumn(
                columnName: 'CoachLinkedLeave',
                label: const Text('CLL'),
                visible: false,
              ),
            ],
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Text('Error: $error, StackTrace: $stackTrace'),
      ),
    );
  }
}
