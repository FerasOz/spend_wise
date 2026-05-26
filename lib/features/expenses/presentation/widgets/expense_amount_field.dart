import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

class ExpenseAmountField extends StatelessWidget {
  const ExpenseAmountField({
    required this.initialValue,
    required this.onSaved,
    super.key,
  });

  final String initialValue;
  final ValueChanged<String?> onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey(initialValue.isEmpty ? 'amount' : 'amount_$initialValue'),
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: LocaleKeys.expenses_form_fields_amount.tr(),
        hintText: '24.99',
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
      ],
      textInputAction: TextInputAction.next,
      validator: (value) {
        final parsed = double.tryParse(value?.trim() ?? '');
        if (parsed == null || parsed <= 0) {
          return LocaleKeys.expenses_form_fields_validAmount.tr();
        }
        return null;
      },
      onSaved: onSaved,
    );
  }
}
