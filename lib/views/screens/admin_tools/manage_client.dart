import 'package:dashboard/models/client.dart';
import 'package:dashboard/models/client_types.dart';
import 'package:dashboard/providers/client_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ManageClient extends ConsumerWidget {
  const ManageClient(this.clientId, {super.key});
  final clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Client> client = ref.watch(singleClientProvider(clientId));
    final formKey = GlobalKey<FormBuilderState>();
    return client.when(
      data: (client) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FormBuilder(
                  key: formKey,
                  child: Column(
                    children: [
                      const Text(
                        'Manage Client Details',
                        style: TextStyle(fontSize: 24),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Column(
                              children: [
                                FormBuilderTextField(
                                  name: 'rollNumber',
                                  initialValue: client.rollNumber,
                                  decoration: const InputDecoration(
                                    labelText: 'Roll Number',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: FormBuilderValidators.required(),
                                ),
                                const SizedBox(height: 10),
                                FormBuilderTextField(
                                  name: 'name',
                                  initialValue: client.name,
                                  decoration: const InputDecoration(
                                    labelText: 'Name',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: FormBuilderValidators.required(),
                                ),
                                const SizedBox(height: 10),
                                FormBuilderTextField(
                                  name: 'town',
                                  initialValue: client.town,
                                  decoration: const InputDecoration(
                                    labelText: 'Town',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: FormBuilderValidators.required(),
                                ),
                                const SizedBox(height: 10),
                                FormBuilderDropdown(
                                  name: "county",
                                  items: [
                                    'Antrim',
                                    'Armagh',
                                    'Carlow',
                                    'Cavan',
                                    'Clare',
                                    'Cork',
                                    'Derry',
                                    'Donegal',
                                    'Down',
                                    'Dublin',
                                    'Fermanagh',
                                    'Galway',
                                    'Kerry',
                                    'Kildare',
                                    'Kilkenny',
                                    'Laois',
                                    'Leitrim',
                                    'Limerick',
                                    'Longford',
                                    'Louth',
                                    'Mayo',
                                    'Meath',
                                    'Monaghan',
                                    'Offaly',
                                    'Roscommon',
                                    'Sligo',
                                    'Tipperary',
                                    'Tyrone',
                                    'Waterford',
                                    'Westmeath',
                                    'Wexford',
                                    'Wicklow'
                                  ]
                                      .map((county) => DropdownMenuItem(
                                          value: county, child: Text(county)))
                                      .toList(),
                                  decoration: const InputDecoration(
                                    labelText: 'County',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: FormBuilderValidators.required(),
                                  initialValue: client.county,
                                ),
                                const SizedBox(height: 10),
                                FormBuilderTextField(
                                  name: 'eircode',
                                  initialValue: client.eircode,
                                  decoration: const InputDecoration(
                                    labelText: 'Eircode',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: FormBuilderValidators.required(),
                                ),
                                const SizedBox(height: 10),
                                FormBuilderDropdown(
                                  name: "type",
                                  items: [
                                    'National School',
                                    'Library',
                                    'Community Group',
                                    'Youth Project',
                                    'Special School',
                                    'Other'
                                  ]
                                      .map((type) => DropdownMenuItem(
                                          value: ClientType.fromString(type),
                                          child: Text(type)))
                                      .toList(),
                                  decoration: const InputDecoration(
                                    labelText: 'Type',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: FormBuilderValidators.required(),
                                  initialValue: client.type.name,
                                ),
                                const SizedBox(height: 10),
                                FormBuilderTextField(
                                  name: 'classrooms',
                                  initialValue: client.classrooms.toString(),
                                  decoration: const InputDecoration(
                                    labelText: 'Classrooms',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.numeric(),
                                  ]),
                                ),
                                const SizedBox(height: 10),
                                FormBuilderTextField(
                                  name: 'students',
                                  initialValue: client.students.toString(),
                                  decoration: const InputDecoration(
                                    labelText: 'Students',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.numeric(),
                                  ]),
                                ),
                                const SizedBox(height: 10),
                                FormBuilderTextField(
                                  name: 'joinDate',
                                  initialValue: client.joinDate?.toString(),
                                  decoration: const InputDecoration(
                                    labelText: 'Join Date',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.dateString(),
                                  ]),
                                ),
                                FormBuilderCheckbox(
                                  name: 'hasHall',
                                  initialValue: client.hasHall,
                                  title: const Text('Has Hall'),
                                ),
                                FormBuilderCheckbox(
                                  name: 'isDeis',
                                  initialValue: client.isDeis,
                                  title: const Text('DEIS Status'),
                                ),
                                FormBuilderCheckbox(
                                  name: 'hasParking',
                                  initialValue: client.hasParking,
                                  title: const Text('Has Parking'),
                                ),
                                FormBuilderCheckbox(
                                  name: 'hasMats',
                                  initialValue: client.hasMats,
                                  title: const Text('Has Mats'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                FormBuilderTextField(
                                  name: 'largestClassSize',
                                  initialValue:
                                      client.largestClassSize?.toString(),
                                  decoration: const InputDecoration(
                                    labelText: 'Largest Class Size',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.numeric(),
                                  ]),
                                ),
                                const SizedBox(height: 10),
                                FormBuilderTextField(
                                  name: 'contactName',
                                  initialValue: client.contactName,
                                  decoration: const InputDecoration(
                                    labelText: 'Contact Name',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                FormBuilderTextField(
                                  name: 'contactEmail',
                                  initialValue: client.contactEmail,
                                  decoration: const InputDecoration(
                                    labelText: 'Contact Email',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.email(),
                                  ]),
                                ),
                                const SizedBox(height: 10),
                                FormBuilderTextField(
                                  name: 'contactPhone',
                                  initialValue: client.contactPhone,
                                  decoration: const InputDecoration(
                                    labelText: 'Contact Phone',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                FormBuilderTextField(
                                  name: 'principalName',
                                  initialValue: client.principalName,
                                  decoration: const InputDecoration(
                                    labelText: 'Principal Name',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                FormBuilderTextField(
                                  name: 'principalEmail',
                                  initialValue: client.principalEmail,
                                  decoration: const InputDecoration(
                                    labelText: 'Principal Email',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.email(),
                                  ]),
                                ),
                                const SizedBox(height: 10),
                                FormBuilderTextField(
                                  name: 'notes',
                                  initialValue: client.notes,
                                  decoration: const InputDecoration(
                                    labelText: 'Notes',
                                    border: OutlineInputBorder(),
                                  ),
                                  minLines: 7,
                                  maxLines: 7,
                                ),
                                const SizedBox(height: 10),
                                FilledButton.icon(
                                    onPressed: () async {
                                      if (formKey.currentState!
                                          .saveAndValidate()) {
                                        final String rollNumber = formKey
                                            .currentState!
                                            .fields['rollNumber']!
                                            .value;
                                        final String name = formKey
                                            .currentState!
                                            .fields['name']!
                                            .value;
                                        final String town = formKey
                                            .currentState!
                                            .fields['town']!
                                            .value;
                                        final String county = formKey
                                            .currentState!
                                            .fields['county']!
                                            .value;
                                        final String eircode = formKey
                                            .currentState!
                                            .fields['eircode']!
                                            .value;
                                        final ClientType type =
                                            ClientType.fromString(formKey
                                                .currentState!
                                                .fields['type']!
                                                .value);
                                        final int classrooms = int.parse(formKey
                                            .currentState!
                                            .fields['classrooms']!
                                            .value);
                                        final int students = int.parse(formKey
                                            .currentState!
                                            .fields['students']!
                                            .value);
                                        final DateTime? joinDate = formKey
                                                    .currentState!
                                                    .fields['joinDate']!
                                                    .value !=
                                                null
                                            ? DateTime.parse(formKey
                                                .currentState!
                                                .fields['joinDate']!
                                                .value)
                                            : null;
                                        final bool? hasHall = formKey
                                            .currentState!
                                            .fields['hasHall']!
                                            .value;
                                        final bool? isDeis = formKey
                                            .currentState!
                                            .fields['isDeis']!
                                            .value;
                                        final bool? hasParking = formKey
                                            .currentState!
                                            .fields['hasParking']!
                                            .value;
                                        final bool? hasMats = formKey
                                            .currentState!
                                            .fields['hasMats']!
                                            .value as bool?;
                                        final int? largestClassSize = formKey
                                                    .currentState!
                                                    .fields['largestClassSize']!
                                                    .value !=
                                                null
                                            ? int.parse(formKey
                                                .currentState!
                                                .fields['largestClassSize']!
                                                .value)
                                            : null;
                                        final String? contactName = formKey
                                            .currentState!
                                            .fields['contactName']!
                                            .value as String?;
                                        final String? contactEmail = formKey
                                            .currentState!
                                            .fields['contactEmail']!
                                            .value as String?;
                                        final String? contactPhone = formKey
                                            .currentState!
                                            .fields['contactPhone']!
                                            .value as String?;
                                        final String? principalName = formKey
                                            .currentState!
                                            .fields['principalName']!
                                            .value as String?;
                                        final String? principalEmail = formKey
                                            .currentState!
                                            .fields['principalEmail']!
                                            .value as String?;
                                        final String? notes = formKey
                                            .currentState!
                                            .fields['notes']!
                                            .value as String?;

                                        final Client updatedClient =
                                            client.copyWith(
                                          rollNumber: rollNumber,
                                          name: name,
                                          town: town,
                                          county: county,
                                          eircode: eircode,
                                          type: type,
                                          classrooms: classrooms,
                                          students: students,
                                          joinDate: joinDate,
                                          hasHall: hasHall,
                                          isDeis: isDeis,
                                          hasParking: hasParking,
                                          hasMats: hasMats,
                                          largestClassSize: largestClassSize,
                                          contactName: contactName,
                                          contactEmail: contactEmail,
                                          contactPhone: contactPhone,
                                          principalName: principalName,
                                          principalEmail: principalEmail,
                                          notes: notes,
                                        );
                                        await ref
                                            .read(singleClientProvider(clientId)
                                                .notifier)
                                            .updateClient(updatedClient);
                                        if (context.mounted) {
                                          context.loaderOverlay.show();
                                          Navigator.pop(context);
                                          context.loaderOverlay.hide();
                                        }
                                      }
                                    },
                                    label: const Text('Save'),
                                    icon: const Icon(Icons.save)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
