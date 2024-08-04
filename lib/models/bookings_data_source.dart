import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/bookings_with_sessions.dart';
import 'package:dashboard/models/client.dart';
import 'package:dashboard/models/client_types.dart';
import 'package:dashboard/providers/bookings_with_sessions_provider.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class BookingsDataSource extends DataGridSource {
  BookingsDataSource({required List<BookingWithSessions> bookingWithSessions}) {
    _bookingWithSessions = bookingWithSessions
        .map<DataGridRow>(
            (BookingWithSessions bookingWithSessions) => DataGridRow(cells: [
                  DataGridCell<String>(
                    columnName: 'Client',
                    value: bookingWithSessions.client.name,
                  ),
                  DataGridCell<String>(
                    columnName: 'Activity',
                    value: bookingWithSessions.activity.name,
                  ),
                  DataGridCell<String>(
                    columnName: 'Coaches',
                    value: bookingWithSessions.coaches
                        .map((coach) => coach.name)
                        .join(', '),
                  ),
                  DataGridCell<DateTime>(
                    columnName: 'Start Date',
                    value: bookingWithSessions.startDate,
                  ),
                  DataGridCell<DateTime>(
                    columnName: 'End Date',
                    value: bookingWithSessions.endDate,
                  ),
                  DataGridCell<String>(
                    columnName: 'No. Sessions',
                    value: bookingWithSessions.sessions.length.toString(),
                  ),
                ]))
        .toList();
  }

  List<DataGridRow> _bookingWithSessions = [];

  @override
  List<DataGridRow> get rows => _bookingWithSessions;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}
