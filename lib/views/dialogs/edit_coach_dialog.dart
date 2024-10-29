import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/activity.dart';
import 'package:dashboard/models/coach.dart';
import 'package:dashboard/models/leave.dart';
import 'package:dashboard/models/session.dart';
import 'package:dashboard/providers/coaches_provider.dart';
import 'package:dashboard/providers/future_sessions_and_leaves.dart';
import 'package:dashboard/providers/leaves_provider.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class EditCoachDialog extends ConsumerStatefulWidget {
  const EditCoachDialog({
    super.key,
    required this.coach,
    required this.activities,
  });

  final Coach coach;
  final List<Activity> activities;

  @override
  ConsumerState<EditCoachDialog> createState() => _EditCoachDialogState();
}

class _EditCoachDialogState extends ConsumerState<EditCoachDialog> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  bool isDirty = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Coach'),
      content: FormBuilder(
          key: formKey,
          onChanged: () {
            setState(() {
              isDirty = formKey.currentState?.fields.entries.any((element) {
                    final String key = element.key;
                    final dynamic value = element.value.value;
                    if (key == 'isAdmin') {
                      return value != widget.coach.isAdmin;
                    } else if (key == 'name') {
                      return value != widget.coach.name;
                    } else {
                      return widget.coach.manuallyBookableActivites
                              .contains(key) !=
                          value;
                    }
                  }) ??
                  false;
            });
          },
          child: SizedBox(
            width: 500,
            child: ListView(
              // Fields to edit: name, manual activities covered (switch) isAdmin (switch)
              children: [
                FormBuilderTextField(
                  name: 'name',
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  initialValue: widget.coach.name,
                  validator: FormBuilderValidators.required(),
                ),
                FormBuilderSwitch(
                  name: 'isAdmin',
                  title: const Text('Is Admin'),
                  initialValue: widget.coach.isAdmin,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text('Can Be MANUALLY Booked For:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                ...widget.activities.map((Activity activity) {
                  return FormBuilderSwitch(
                    name: activity.id,
                    title: Text(activity.name),
                    initialValue: widget.coach.manuallyBookableActivites
                        .contains(activity.id),
                  );
                }),
              ],
            ),
          )),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          // Only enable the button if the form has been edited
          onPressed: isDirty
              ? () async {
                  if (formKey.currentState?.saveAndValidate() ?? false) {
                    final Map<String, dynamic> formValues =
                        formKey.currentState?.value ?? {};
                    final List<String> manuallyBookableActivities = widget
                        .activities
                        .where((Activity activity) =>
                            formValues[activity.id] == true)
                        .map((Activity activity) => activity.id)
                        .toList();
                    final Coach updatedCoach = widget.coach.copyWith(
                        name: formValues['name'],
                        isAdmin: formValues['isAdmin'],
                        manuallyBookableActivites: manuallyBookableActivities);
                    await ref
                        .read(coachesProvider.notifier)
                        .updateCoach(updatedCoach);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                }
              : null,
          child: const Text('Submit Changes'),
        ),
      ],
    );
  }
}
