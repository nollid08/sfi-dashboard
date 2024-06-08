import 'package:dashboard/providers/activity_provider.dart';
import 'package:dashboard/views/widgets/form_fields/icon_picker_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddActivityDialog extends ConsumerWidget {
  const AddActivityDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormBuilderState>();
    return AlertDialog(
      title: const Text('Add Activity'),
      content: SizedBox(
        height: 350,
        child: FormBuilder(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormBuilderTextField(
                name: 'name',
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: FormBuilderValidators.required(),
              ),
              const IconPickerFormField(
                name: 'icon',
                initialIcon: Icons.sports,
              ),
              SizedBox(
                height: 100,
                width: 100,
                child: FormBuilderColorPickerField(
                  name: 'color',
                  decoration: const InputDecoration(
                    labelText: 'Color',
                  ),
                  colorPickerType: ColorPickerType.materialPicker,
                  initialValue: Colors.purple,
                  validator: FormBuilderValidators.required(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.saveAndValidate()) {
              final Map<String, dynamic> values = formKey.currentState!.value;
              ref.read(activitiesProvider.notifier).addActivity(
                    name: values['name'] as String,
                    icon: values['icon'] as IconData,
                    color: values['color'] as Color,
                  );
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
