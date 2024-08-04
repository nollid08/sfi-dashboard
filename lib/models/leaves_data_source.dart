import 'package:dashboard/models/coach_linked_leave.dart';
import 'package:dashboard/models/leave.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class LeavesDataSource extends DataGridSource {
  LeavesDataSource({
    required List<CoachLinkedLeave> coachLinkedLeaves,
  }) {
    _coachLinkedLeave = coachLinkedLeaves
        .map<DataGridRow>(
          (CoachLinkedLeave coachLinkedLeave) => DataGridRow(
            cells: [
              DataGridCell<String>(
                columnName: 'CoachName',
                value: coachLinkedLeave.coach.name,
              ),
              DataGridCell<DateTime>(
                columnName: 'StartDate',
                value: coachLinkedLeave.startDate,
              ),
              DataGridCell<DateTime>(
                columnName: 'EndDate',
                value: coachLinkedLeave.endDate,
              ),
              DataGridCell<String>(
                columnName: 'LeaveType',
                value: coachLinkedLeave.type.toString(),
              ),
              DataGridCell<String>(
                columnName: 'Status',
                value: coachLinkedLeave.status.toString(),
              ),
              DataGridCell<CoachLinkedLeave>(
                columnName: 'CoachLinkedLeave',
                value: coachLinkedLeave,
              ),
            ],
          ),
        )
        .toList();
  }

  List<DataGridRow> _coachLinkedLeave = [];

  @override
  List<DataGridRow> get rows => _coachLinkedLeave;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final CoachLinkedLeave coachLinkedLeave = row.getCells().last.value;
    return DataGridRowAdapter(
        color: coachLinkedLeave.status == LeaveStatus.pending
            ? Colors.orange
            : coachLinkedLeave.status == LeaveStatus.approved
                ? Colors.green
                : coachLinkedLeave.status == LeaveStatus.rejected
                    ? Colors.red
                    : coachLinkedLeave.status == LeaveStatus.completed
                        ? Colors.blue
                        : Colors.yellow,
        cells: row.getCells().map<Widget>((dataGridCell) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Text(dataGridCell.value.toString()),
          );
        }).toList());
  }
}
