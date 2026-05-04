import 'package:flutter/material.dart';

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
      decoration: const InputDecoration(
        labelText: 'Amount',
        hintText: '24.99',
        prefixText: '\$ ',
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.next,
      validator: (value) {
        final parsed = double.tryParse(value?.trim() ?? '');
        if (parsed == null || parsed <= 0) {
          return 'Enter a valid amount.';
        }
        return null;
      },
      onSaved: onSaved,
    );
  }
}
