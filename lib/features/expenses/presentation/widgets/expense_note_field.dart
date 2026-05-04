import 'package:flutter/material.dart';

class ExpenseNoteField extends StatelessWidget {
  const ExpenseNoteField({
    required this.initialValue,
    required this.onSaved,
    super.key,
  });

  final String? initialValue;
  final ValueChanged<String?> onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey(
        initialValue?.isEmpty ?? true ? 'note' : 'note_$initialValue',
      ),
      initialValue: initialValue ?? '',
      decoration: const InputDecoration(
        labelText: 'Note',
        hintText: 'Optional details',
      ),
      minLines: 3,
      maxLines: 5,
      onSaved: onSaved,
    );
  }
}
