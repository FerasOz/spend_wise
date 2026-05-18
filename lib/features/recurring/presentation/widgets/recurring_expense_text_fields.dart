import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_spacing.dart';

class RecurringExpenseTextFields extends StatelessWidget {
  const RecurringExpenseTextFields({
    required this.title,
    required this.amountValue,
    required this.onTitleSaved,
    required this.onAmountSaved,
    super.key,
  });

  final String? title;
  final String? amountValue;
  final ValueChanged<String?> onTitleSaved;
  final ValueChanged<String?> onAmountSaved;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: title,
          decoration: const InputDecoration(labelText: 'Title'),
          validator: (value) => (value ?? '').trim().isEmpty ? 'Enter a title' : null,
          onSaved: onTitleSaved,
        ),
        SizedBox(height: AppSpacing.lg.h),
        TextFormField(
          initialValue: amountValue,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Amount'),
          validator: (value) {
            final amount = double.tryParse((value ?? '').trim());
            return amount == null || amount <= 0 ? 'Enter a valid amount' : null;
          },
          onSaved: onAmountSaved,
        ),
      ],
    );
  }
}
