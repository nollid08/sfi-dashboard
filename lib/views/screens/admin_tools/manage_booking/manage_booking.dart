import 'package:dashboard/models/booking.dart';
import 'package:dashboard/models/client.dart';
import 'package:dashboard/providers/booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ManageBooking extends ConsumerWidget {
  final String id;

  const ManageBooking({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Booking> booking =
        ref.watch(individualBookingProvider(id));
    final formKey = GlobalKey<FormBuilderState>();

    return booking.when(
      data: (Booking booking) {
        return SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Booking Info',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Flexible(
                  child: ClientInfo(
                    client: booking.client,
                  ),
                ),
                Flexible(
                    child: Card(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Booking Info',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.calendar_today),
                            title: const Text('Start Date'),
                            subtitle: Text(DateFormat("dd/MM/yyyy")
                                .format(booking.startDate)),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.calendar_today),
                            title: const Text('End Date'),
                            subtitle: Text(DateFormat("dd/MM/yyyy")
                                .format(booking.endDate)),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.sports),
                            title: const Text('Activity'),
                            subtitle: Text(booking.activity.name),
                          ),
                          const Text(
                            'Booking Notes',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          FormBuilder(
                            key: formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: FormBuilderTextField(
                                    name: 'notes',
                                    maxLines: 12,
                                    decoration: const InputDecoration(
                                      labelText: 'Booking Notes',
                                      border: OutlineInputBorder(),
                                    ),
                                    initialValue: booking.notes,
                                  ),
                                ),
                                FilledButton(
                                  onPressed: () async {
                                    if (formKey.currentState
                                            ?.saveAndValidate() ??
                                        false) {
                                      final Map<String, dynamic> formValues =
                                          formKey.currentState!.value;
                                      final String newNotes =
                                          formValues['notes'];
                                      final String bookingId = booking.id;
                                      await ref
                                          .read(individualBookingProvider(
                                                  bookingId)
                                              .notifier)
                                          .updateBookingNotes(
                                            id: bookingId,
                                            notes: newNotes,
                                          );
                                    }
                                  },
                                  child: const Text('Update Booking Notes'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
              ]),
            ],
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }
}

class ClientInfo extends ConsumerWidget {
  const ClientInfo({
    super.key,
    required this.client,
  });

  final Client client;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Client Info',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Name'),
                subtitle: Text(client.name),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.house),
                title: const Text('Type'),
                subtitle: Text(client.type.name),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.school),
                title: const Text('Roll Number'),
                subtitle: Text(client.rollNumber),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.location_city),
                title: const Text('Town'),
                subtitle: Text(client.town),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text('County'),
                subtitle: Text(client.county),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Eircode'),
                subtitle: Text(client.eircode),
              ),
              const Divider(),
              if (client.joinDate != null)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Join Date'),
                      subtitle: Text(
                          DateFormat("dd/MM//yyyy").format(client.joinDate!)),
                    ),
                    const Divider(),
                  ],
                ),
              if (client.contactName != null)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.badge),
                      title: const Text('Contact Name'),
                      subtitle: Text(client.contactName!),
                    ),
                    const Divider(),
                  ],
                ),
              if (client.contactEmail != null)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Contact Email'),
                      subtitle: Text(client.contactEmail!),
                    ),
                    const Divider(),
                  ],
                ),
              if (client.contactPhone != null)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: const Text('Contact Phone'),
                      subtitle: Text(client.contactPhone!),
                    ),
                    const Divider(),
                  ],
                ),
              ListTile(
                leading: const Icon(Icons.group),
                title: Text(client.isDeis ? 'DEIS' : 'Non-DEIS'),
              ),
              const Divider(),
              if (client.hasMats != null)
                ListTile(
                  leading: const Icon(Icons.fitness_center),
                  title: Text(client.hasMats! ? 'Has Mats' : 'Has No Mats'),
                ),
              if (client.largestClassSize != null)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.group_add),
                      title: const Text('Largest Class Size'),
                      subtitle: Text(client.largestClassSize!.toString()),
                    ),
                    const Divider(),
                  ],
                ),
              if (client.hasParking != null)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.local_parking),
                      title: Text(
                        client.hasParking! ? 'Has Parking' : 'Has No Parking',
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              if (client.notes != null)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.notes),
                      title: const Text('Notes'),
                      subtitle: Text(client.notes!),
                    ),
                    const Divider(),
                  ],
                ),
              ElevatedButton.icon(
                onPressed: () {
                  var route = '/adminTools/manageClients/${client.id}';
                  // ref
                  //     .read(selectedScreenIndexProvider.notifier)
                  //     .updateIndexBasedOnRouteName(route);
                  context.go(route);
                },
                label: const Text('Edit Client Info'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
