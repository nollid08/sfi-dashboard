import 'package:dashboard/models/client.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ClientDataSource extends DataGridSource {
  ClientDataSource({required List<Client> clients}) {
    _clients = clients
        .map<DataGridRow>((Client client) => DataGridRow(cells: [
              DataGridCell<String>(
                columnName: 'RollNumber',
                value: client.rollNumber,
              ),
              DataGridCell<String>(
                columnName: 'Name',
                value: client.name,
              ),
              DataGridCell<String>(
                columnName: 'Town',
                value: client.town,
              ),
              DataGridCell<String>(
                columnName: 'County',
                value: client.county,
              ),
              DataGridCell<String>(
                columnName: 'Eircode',
                value: client.eircode,
              ),
              DataGridCell<String>(
                columnName: 'Type',
                value: client.type.name,
              ),
              DataGridCell<String>(
                columnName: 'Deis Status',
                value: client.isDeis ? 'Yes' : 'No',
              ),
              DataGridCell<int>(
                columnName: 'Classrooms',
                value: client.classrooms,
              ),
              DataGridCell<int>(
                columnName: 'Pupils',
                value: client.students,
              ),
              DataGridCell<Client>(
                columnName: 'Client',
                value: client,
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
        padding: const EdgeInsets.all(16.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}
