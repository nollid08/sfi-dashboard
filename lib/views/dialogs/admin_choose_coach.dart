import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/coach.dart';
import 'package:dashboard/models/leave.dart';
import 'package:dashboard/models/session.dart';
import 'package:dashboard/providers/coaches_provider.dart';
import 'package:dashboard/providers/future_sessions_and_leaves.dart';
import 'package:dashboard/providers/leaves_provider.dart';
import 'package:dashboard/views/dialogs/request_annual_leave_dialog.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class AdminChooseCoach extends ConsumerWidget {
  AdminChooseCoach({
    super.key,
    this.onPop,
  });

  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final Function? onPop;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Coach>> coachesRef = ref.watch(coachesProvider);
    return AlertDialog(
      title: const Text('Request Annual Leave'),
      content: FormBuilder(
        key: formKey,
        child: coachesRef.when(
          data: (List<Coach> coaches) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormBuilderDropdown<Coach>(
                  name: "coach",
                  items: coaches.map((Coach coach) {
                    return DropdownMenuItem(
                      value: coach,
                      child: Text(coach.name),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Select Coach',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.required(),
                ),
              ],
            );
          },
          loading: () => const SizedBox.square(
            dimension: 50,
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) {
            return Text('Error: $error, $stackTrace');
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            if (formKey.currentState!.saveAndValidate()) {
              final Map<String, dynamic> formData = formKey.currentState!.value;
              final Coach coach = formData['coach'] as Coach;

              Navigator.of(context).pop();
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return RequestAnnualLeaveDialog(
                    coachUid: coach.uid,
                    onPop: onPop,
                  );
                },
              );
            }
          },
          child: const Text('Request Annual Leave '),
        ),
      ],
    );
  }
}
