import 'package:dashboard/models/client_data_source.dart';
import 'package:dashboard/models/client.dart';
import 'package:dashboard/providers/clients_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: SfDataGrid(
                columnWidthMode: ColumnWidthMode.fill,
                source: ClientDataSource(clients: clientsList),
                headerRowHeight: 80,
                headerGridLinesVisibility: GridLinesVisibility.both,
                gridLinesVisibility: GridLinesVisibility.both,
                allowFiltering: true,
                allowSorting: true,
                columns: <GridColumn>[
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
                    columnName: 'AL1',
                    label: Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: const Text('Address Line One'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'AL2',
                    label: Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Address Line 2',
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Eircode',
                    label: Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: const Text('Eircode'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'RollNumber',
                    label: Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: const Text('Roll Number'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Type',
                    label: Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: const Text('RollNumber'),
                    ),
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
        error: (error, stackTrace) => Text('Error: $error'),
      ),
    );
  }
}
