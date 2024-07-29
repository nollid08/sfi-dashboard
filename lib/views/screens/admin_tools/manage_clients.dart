import 'package:dashboard/models/client_data_source.dart';
import 'package:dashboard/models/client.dart';
import 'package:dashboard/providers/clients_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ManageSchools extends ConsumerWidget {
  const ManageSchools({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Retrieve the list of schools from the provider
    final AsyncValue<List<Client>> clients = ref.watch(clientsProvider);

    return Scaffold(
      body: clients.when(
        data: (clientsList) {
          var clientDataSource = ClientDataSource(clients: clientsList);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: SfDataGrid(
                columnWidthMode: ColumnWidthMode.auto,
                source: clientDataSource,
                headerRowHeight: 80,
                headerGridLinesVisibility: GridLinesVisibility.both,
                gridLinesVisibility: GridLinesVisibility.both,
                allowFiltering: true,
                allowSorting: true,
                allowEditing: true,
                onCellTap: (details) {
                  final int selectedRowIndex =
                      details.rowColumnIndex.rowIndex - 1;
                  final DataGridRow row = clientDataSource.effectiveRows
                      .elementAt(selectedRowIndex);
                  final Client client = row.getCells().last.value;
                  context.push('/adminTools/manageClients/${client.id}');
                },
                selectionMode: SelectionMode.multiple,
                navigationMode: GridNavigationMode.row,
                // onCellTap: (details) {
                //   print(details.);
                // },
                columns: <GridColumn>[
                  GridColumn(
                    columnName: 'RollNumber',
                    label: Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: const Text('Roll Number'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Name',
                    label: Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Name',
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Town',
                    label: Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: const Text('Town'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'County',
                    label: Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'County',
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Eircode',
                    label: Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Eircode',
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Type',
                    label: Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: const Text('Type'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Deis Status',
                    label: Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: const Text('Deis Status'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Classrooms',
                    label: Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: const Text('Classrooms'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Pupils',
                    label: Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: const Text('Pupils'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Client',
                    label: Container(),
                    width: 0,
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(
          child: SizedBox.square(
            dimension: 100,
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stackTrace) => Text('Error: $error, $stackTrace'),
      ),
    );
  }
}
