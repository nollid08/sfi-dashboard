import 'package:dashboard/models/client.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ClientDataSource extends DataGridSource {
  ClientDataSource({required List<Client> clients}) {
    _clients = clients
        .map<DataGridRow>((Client client) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'Name', value: client.name),
              DataGridCell<String>(
                  columnName: 'AL1', value: client.addressLineOne),
              DataGridCell<String>(
                  columnName: 'AL2', value: client.addressLineTwo),
              DataGridCell<String>(
                  columnName: 'Eircode', value: client.eircode),
              DataGridCell<String>(
                  columnName: 'RollNumber', value: client.rollNumber),
              DataGridCell<String>(
                columnName: 'Type',
                value: client.type.name,
              ),
            ]))
        .toList();
  }

  List<DataGridRow> _clients = [];

  @override
  List<DataGridRow> get rows => _clients;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}
