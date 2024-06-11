import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class NumberPickerFormField extends StatelessWidget {
  final String name;

  const NumberPickerFormField({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<int>(
        initialValue: 1,
        name: name,
        builder: (FormFieldState<int> state) {
          return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller:
                        TextEditingController(text: state.value.toString()),
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
                      state.didChange(int.parse(value));
                    },
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (state.value != null) {
                            state.didChange(state.value! + 1);
                          }
                        },
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(EdgeInsets.zero),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                        icon: const Icon(
                          Icons.arrow_upward,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        child: IconButton(
                          onPressed: state.value! > 1
                              ? () {
                                  state.didChange(state.value! - 1);
                                }
                              : null,
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all(EdgeInsets.zero),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                          icon: const Icon(
                            Icons.arrow_downward,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]);
        });
  }
}
