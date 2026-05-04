import 'package:flutter/material.dart';

class ExpenseTitleField extends StatelessWidget {
  const ExpenseTitleField({
    required this.initialValue,
    required this.onSaved,
    super.key,
  });

  final String initialValue;
  final ValueChanged<String?> onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey(initialValue.isEmpty ? 'title' : 'title_$initialValue'),
      initialValue: initialValue,
      decoration: const InputDecoration(
        labelText: 'Title',
        hintText: 'Groceries',
      ),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Title is required.';
        }
        return null;
      },
      onSaved: onSaved,
    );
  }
}
