import 'package:dashboard/models/session.dart';
import 'package:dashboard/providers/sessions_provider.dart';
import 'package:dashboard/views/widgets/manage_session_times.dart';
import 'package:dashboard/views/widgets/manage_sessions_assigned_coaches.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ManageSession extends ConsumerStatefulWidget {
  final String bookingId;
  final int sessionIndex;

  const ManageSession({
    super.key,
    required this.bookingId,
    required this.sessionIndex,
  });

  @override
  ConsumerState<ManageSession> createState() => _ManageSessionState();
}

class _ManageSessionState extends ConsumerState<ManageSession> {
  final formKey = GlobalKey<FormBuilderState>();
  bool datesHaveChanged = false;
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Session>> sessions =
        ref.watch(sessionsProvider(bookingIds: [widget.bookingId].lock));

    if (widget.sessionIndex == -1) {
      return Text(
          'This booking does not have a session no. ${widget.sessionIndex + 1}');
    }

    return sessions.when(
      data: (List<Session> sessions) {
        final Session session = sessions[widget.sessionIndex];
        return Flexible(
          flex: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Session No. ${widget.sessionIndex + 1}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: Column(
                        children: [
                          ManageSessionTimes(
                            session: session,
                          ),
                          ManageSessionsAssignedCoaches(
                            session: session,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ManageSessionNotes(
                            session: session,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton.icon(
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          Colors.lightBlue),
                                ),
                                onPressed: () {
                                  ref
                                      .read(sessionsProvider(
                                              bookingIds:
                                                  [widget.bookingId].lock)
                                          .notifier)
                                      .deleteSession(
                                        sessionId: session.id,
                                      );
                                  context.go(
                                    '/adminTools/manageBookings/${widget.bookingId}',
                                  );
                                },
                                label: const Text(
                                  'Delete Session',
                                  style: TextStyle(color: Colors.white),
                                ),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}

class ManageSessionNotes extends ConsumerWidget {
  const ManageSessionNotes({
    super.key,
    required this.session,
  });

  final Session session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormBuilderState>();
    return FormBuilder(
      key: formKey,
      child: Card(
        surfaceTintColor: Colors.blue[600],
        shadowColor: Colors.blue[900],
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              // Show camp notes in a textbox
              children: [
                const Text(
                  'Camp Notes',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FormBuilderTextField(
                    name: 'camp-notes',
                    maxLines: 12,
                    decoration: const InputDecoration(
                      labelText: 'Session Notes',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: session.notes,
                  ),
                ),
                FilledButton(
                  onPressed: () async {
                    if (formKey.currentState?.saveAndValidate() ?? false) {
                      final Map<String, dynamic> formValues =
                          formKey.currentState!.value;
                      final String newNotes = formValues['camp-notes'];
                      final String bookingId = session.bookingId;
                      final String sessionId = session.id;
                      await ref
                          .read(sessionsProvider(bookingIds: [bookingId].lock)
                              .notifier)
                          .updateSessionNotes(
                            sessionId: sessionId,
                            newNotes: newNotes,
                          );
                    }
                  },
                  child: const Text('Update Camp Notes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
