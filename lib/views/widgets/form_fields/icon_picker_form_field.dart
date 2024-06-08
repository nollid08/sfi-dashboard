import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class IconPickerFormField extends StatelessWidget {
  final String name;
  final IconData initialIcon;

  const IconPickerFormField({
    Key? key,
    required this.name,
    required this.initialIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<IconData>(
        name: name,
        builder: (FormFieldState<IconData> state) {
          return InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Choose an icon',
            ),
            child: Row(
              children: [
                Icon(
                  state.value ?? initialIcon,
                  size: 36,
                ),
                const SizedBox(
                    width: 8), // Add some space between the icon and the button
                Expanded(
                  child: FilledButton(
                    onPressed: () async {
                      final IconData icon = await _pickIcon(context);
                      state.didChange(icon);
                    },
                    child: const Text('Pick Icon'),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<IconData> _pickIcon(BuildContext context) async {
    final IconData? icon = await showIconPicker(context, adaptiveDialog: false);
    return icon ?? initialIcon;
  }
}
