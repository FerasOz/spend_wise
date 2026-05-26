import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

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
      decoration: InputDecoration(
        labelText: LocaleKeys.expenses_form_fields_title.tr(),
        hintText: LocaleKeys.expenses_form_fields_titlePlaceholder.tr(),
      ),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return LocaleKeys.expenses_form_fields_titleRequired.tr();
        }
        return null;
      },
      onSaved: onSaved,
    );
  }
}
