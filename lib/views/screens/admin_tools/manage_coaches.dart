import 'package:dashboard/models/activity.dart';
import 'package:dashboard/models/coach.dart';
import 'package:dashboard/models/coaches_data_source.dart';
import 'package:dashboard/providers/activity_provider.dart';
import 'package:dashboard/providers/coaches_provider.dart';
import 'package:dashboard/views/dialogs/edit_coach_dialog.dart';
import 'package:dashboard/views/dialogs/request_annual_leave_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ManageCoachesScreen extends ConsumerStatefulWidget {
  const ManageCoachesScreen({super.key});

  @override
  ConsumerState<ManageCoachesScreen> createState() =>
      _ManageCoachesScreenState();
}

class _ManageCoachesScreenState extends ConsumerState<ManageCoachesScreen> {
  int? selectedCoachindex;
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Coach>> coachesRef = ref.watch(coachesProvider);
    final AsyncValue<List<Activity>> activitiesRef =
        ref.watch(activitiesProvider);

    return coachesRef.when(
      data: (List<Coach> coaches) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: activitiesRef.when(
              data: (List<Activity> activities) {
                final CoachesRatingsDataSource coachesDataSource =
                    CoachesRatingsDataSource(
                  coaches: coaches,
                  activities: activities,
                  ref: ref,
                );

                return SfDataGrid(
                  source: coachesDataSource,
                  columnWidthMode: ColumnWidthMode.fill,
                  headerRowHeight: 80,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  gridLinesVisibility: GridLinesVisibility.both,
                  allowFiltering: true,
                  allowSorting: true,
                  allowEditing: true,
                  selectionMode: SelectionMode.single,
                  navigationMode: GridNavigationMode.cell,
                  allowColumnsResizing: true,
                  onCellTap: (details) {
                    openEditCoachModal(details, coachesDataSource, activities);
                  },
                  onCellDoubleTap: (details) {
                    openEditCoachModal(details, coachesDataSource, activities);
                  },
                  columns: [
                        GridColumn(
                          columnName: 'coachId',
                          visible: false,
                          label: const Text("ID"),
                          allowEditing: false,
                        ),
                        GridColumn(
                          columnName: 'coachName',
                          allowEditing: false,
                          columnWidthMode: ColumnWidthMode.fitByCellValue,
                          label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text("Coach"),
                          ),
                        )
                      ] +
                      activities.map((Activity activity) {
                        return GridColumn(
                          columnName: activity.id,
                          label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text(activity.name),
                          ),
                        );
                      }).toList(),
                );
              },
              error: (error, stackTrace) => throw error,
              loading: () => const SizedBox.shrink(),
            ),
          ),
        );
      },
      error: (error, stackTrace) => throw error,
      loading: () => const SizedBox.shrink(),
    );
  }

  void openEditCoachModal(details, coachesDataSource, activities) {
    // If the user taps on the coach name, show the dialog
    if (details.rowColumnIndex.columnIndex == 1) {
      final int selectedRowIndex = details.rowColumnIndex.rowIndex - 1;
      final DataGridRow row =
          coachesDataSource.rows.elementAt(selectedRowIndex);
      final Coach coach = row.getCells().first.value;
      showDialog(
        context: context,
        builder: (context) {
          return EditCoachDialog(
            coach: coach,
            activities: activities,
          );
        },
      );
    }
  }
}
