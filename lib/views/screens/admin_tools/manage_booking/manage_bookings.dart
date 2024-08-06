import 'package:dashboard/models/bookings_data_source.dart';
import 'package:dashboard/models/bookings_with_sessions.dart';
import 'package:dashboard/providers/bookings_with_sessions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ManageBookings extends ConsumerStatefulWidget {
  const ManageBookings({super.key});

  @override
  ConsumerState<ManageBookings> createState() => _ManageBookingsState();
}

class _ManageBookingsState extends ConsumerState<ManageBookings> {
  late Map<String, double> columnWidths = {
    'Client': double.nan,
    'Activity': double.nan,
    'Coaches': double.nan,
    'Start Date': double.nan,
    'End Date': double.nan,
    'No. Sessions': double.nan,
  };

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<BookingWithSessions>> bookingsWithSessions =
        ref.watch(bookingsWithSessionsProvider);
    return bookingsWithSessions.when(
      data: (List<BookingWithSessions> bookingsWithSessions) {
        if (bookingsWithSessions.isEmpty) {
          return const Center(
            child: Text('No bookings'),
          );
        }
        final BookingsDataSource bookingsDataSource =
            BookingsDataSource(bookingWithSessions: bookingsWithSessions);
        return SfDataGrid(
          columnWidthMode: ColumnWidthMode.fill,
          source: bookingsDataSource,
          headerRowHeight: 80,
          headerGridLinesVisibility: GridLinesVisibility.both,
          gridLinesVisibility: GridLinesVisibility.both,
          allowFiltering: true,
          allowSorting: true,
          allowEditing: true,
          onCellTap: (details) {
            final int selectedRowIndex = details.rowColumnIndex.rowIndex - 1;
            final DataGridRow row =
                bookingsDataSource.effectiveRows.elementAt(selectedRowIndex);
            final BookingWithSessions bookingWithSessions =
                bookingsWithSessions[selectedRowIndex];
            context.go('/adminTools/manageBookings/${bookingWithSessions.id}');
          },
          selectionMode: SelectionMode.multiple,
          navigationMode: GridNavigationMode.row,
          allowColumnsResizing: true,
          onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
            setState(() {
              columnWidths[details.column.columnName] = details.width;
            });
            return true;
          },
          columns: <GridColumn>[
            GridColumn(
              columnName: 'Client',
              label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: const Text(
                  'Client',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              width: columnWidths['Client']!,
            ),
            GridColumn(
              columnName: 'Activity',
              label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: const Text(
                  'Activity',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              width: columnWidths['Activity']!,
            ),
            GridColumn(
              columnName: 'Coaches',
              label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: const Text(
                  'Coaches',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              width: columnWidths['Coaches']!,
            ),
            GridColumn(
              columnName: 'Start Date',
              label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: const Text(
                  'Start Date',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              width: columnWidths['Start Date']!,
            ),
            GridColumn(
              columnName: 'End Date',
              label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: const Text(
                  'End Date',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              width: columnWidths['End Date']!,
            ),
            GridColumn(
              columnName: 'No. Sessions',
              label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: const Text(
                  'No. Sessions',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              width: columnWidths['No. Sessions']!,
            ),
            GridColumn(
              columnName: 'bookingWithSessions',
              label: Container(),
              width: 0,
              visible: false,
            ),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error: $error, $stackTrace'),
    );
  }
}
