import 'package:dashboard/models/activity.dart';
import 'package:dashboard/models/client.dart';
import 'package:dashboard/providers/activity_provider.dart';
import 'package:dashboard/providers/clients_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

class GatherBookingInfo extends ConsumerWidget {
  const GatherBookingInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormBuilderState>();

    final AsyncValue<List<Client>> clients = ref.watch(clientsProvider);
    final AsyncValue<List<Activity>> activities = ref.watch(activitiesProvider);

    return FormBuilder(
      key: formKey,
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 500,
                  child: clients.when(
                    data: (clientsList) =>
                        FormBuilderSearchableDropdown<String>(
                      popupProps: const PopupProps.menu(showSearchBox: true),
                      dropdownSearchDecoration: const InputDecoration(
                        hintText: 'Search',
                        labelText: 'Search',
                      ),
                      name: 'client',
                      validator: FormBuilderValidators.required(),
                      items: clientsList
                          .map((client) =>
                              '${client.rollNumber} - ${client.name}')
                          .toList(),
                      initialValue:
                          '${clientsList.first.rollNumber} - ${clientsList.first.name}',
                      valueTransformer: (value) {
                        return clientsList.firstWhere((client) =>
                            '${client.rollNumber} - ${client.name}' == value);
                      },
                      decoration:
                          const InputDecoration(labelText: 'Select a Client'),
                      compareFn: (client, candidate) => client == candidate,
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (error, st) => Text('Error: $error, stack: $st'),
                  ),
                ),
                const VerticalDivider(),
                SizedBox(
                  width: 300,
                  child: activities.when(
                    data: (activitiesList) =>
                        FormBuilderSearchableDropdown<String>(
                      popupProps: const PopupProps.menu(showSearchBox: true),
                      dropdownSearchDecoration: const InputDecoration(
                        hintText: 'Search',
                        labelText: 'Search',
                      ),
                      name: 'activity',
                      validator: FormBuilderValidators.required(),
                      items:
                          activitiesList.map((client) => client.name).toList(),
                      initialValue: activitiesList.first.name,
                      valueTransformer: (value) {
                        if (value == null) {
                          return activitiesList.first;
                        }
                        return activitiesList
                            .firstWhere((activity) => activity.name == value);
                      },
                      decoration: const InputDecoration(
                          labelText: 'Select an Activity'),
                      compareFn: (activity, candidate) => activity == candidate,
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (error, _) => Text('Error: $error'),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FilledButton(
              onPressed: () {
                if (!formKey.currentState!.saveAndValidate()) {
                  return;
                }
                final formData = formKey.currentState!.value;
                final selectedClient = formData['client'] as Client;
                final selectedActivity = formData['activity'] as Activity;
                final selections = {
                  'client': selectedClient,
                  'activity': selectedActivity,
                };
                GoRouter.of(context).go('/adminTools/createManualBooking/date',
                    extra: selections);
              },
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }
}
