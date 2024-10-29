import 'package:dashboard/models/activity.dart';
import 'package:dashboard/models/coach.dart';
import 'package:dashboard/models/coach_linked_leave.dart';
import 'package:dashboard/providers/activity_provider.dart';
import 'package:dashboard/providers/coaches_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CoachesRatingsDataSource extends DataGridSource {
  final WidgetRef ref;
  final List<Coach> coaches;
  final List<Activity> activities;

  CoachesRatingsDataSource({
    required this.coaches,
    required this.activities,
    required this.ref,
  }) {
    _coachRatings = coaches.map<DataGridRow>((Coach coach) {
      return DataGridRow(
          cells: [
                DataGridCell<Coach>(columnName: 'coach', value: coach),
                DataGridCell<dynamic>(
                  columnName: 'coachName',
                  value: coach.name,
                )
              ] +
              activities.map<DataGridCell<dynamic>>((Activity activity) {
                return DataGridCell<dynamic>(
                    columnName: activity.id,
                    value: coach.autoActivityRatings[activity.id] ?? 0);
              }).toList());
    }).toList();
  }

  List<DataGridRow> _coachRatings = [];

  @override
  List<DataGridRow> get rows => _coachRatings;

  Object? newCellValue;

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    // Text going to display on editable widget
    final String displayText = dataGridRow
        .getCells()
        .where((DataGridCell dataGridCell) =>
            dataGridCell.columnName == column.columnName)
        .toList()[0]
        .value
        .toString();

    final bool isNumericType = column.columnName != 'coach';
    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: isNumericType ? Alignment.centerRight : Alignment.centerLeft,
      child: TextField(
        autofocus: true,
        controller: TextEditingController(text: displayText),
        textAlign: isNumericType ? TextAlign.right : TextAlign.left,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
        ),
        keyboardType: isNumericType ? TextInputType.number : TextInputType.text,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            if (isNumericType) {
              newCellValue = int.parse(value);
              print("New cell value: $newCellValue");
            } else {
              newCellValue = value;
            }
          } else {
            newCellValue = null;
          }
        },
        onSubmitted: (x) {
          onCellSubmit(dataGridRow, rowColumnIndex, column);
        },
      ),
    );
  }

  @override
  Future<void> onCellSubmit(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column) async {
    print("Submitting $newCellValue");
    final bool isCoachScore =
        column.columnName != 'coachName' && column.columnName != 'coach';
    if (newCellValue != null) {
      if (isCoachScore) {
        final activityId = activities
            .firstWhere((Activity activity) => activity.id == column.columnName)
            .id;
        ref.read(coachesProvider.notifier).updateAutoActivityRating(
            activityId: activityId,
            coachId: dataGridRow.getCells()[0].value.uid,
            newRating: newCellValue as int);
      }
    }

    // Reset the newCellValue to null
    newCellValue = null;
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      if (dataGridCell.columnName == 'coach' ||
          dataGridCell.columnName == 'coachName') {
        return Container(
          color: Colors.blue,
          padding: const EdgeInsets.all(16.0),
          child: Text(dataGridCell.value.toString()),
        );
      }
      return Container(
        color: dataGridCell.value > 0 ? Colors.green : Colors.red,
        padding: const EdgeInsets.all(16.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}
