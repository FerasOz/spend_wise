import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

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
          decoration: InputDecoration(
            labelText: LocaleKeys.recurring_form_fields_title.tr(),
          ),
          validator: (value) => (value ?? '').trim().isEmpty
              ? LocaleKeys.recurring_form_validation_enterTitle.tr()
              : null,
          onSaved: onTitleSaved,
        ),
        SizedBox(height: AppSpacing.lg.h),
        TextFormField(
          initialValue: amountValue,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: LocaleKeys.recurring_form_fields_amount.tr(),
          ),
          validator: (value) {
            final amount = double.tryParse((value ?? '').trim());
            return amount == null || amount <= 0
                ? LocaleKeys.recurring_form_validation_enterAmount.tr()
                : null;
          },
          onSaved: onAmountSaved,
        ),
      ],
    );
  }
}
