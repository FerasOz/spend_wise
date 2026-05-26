import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

import '../../../../core/base/requests_status.dart';

typedef SubmitExpenseCallback = Future<void> Function();

class ExpenseSubmitButton extends StatelessWidget {
  const ExpenseSubmitButton({
    required this.isEditing,
    required this.submissionStatus,
    required this.onSubmit,
    super.key,
  });

  final bool isEditing;
  final RequestsStatus submissionStatus;
  final SubmitExpenseCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: submissionStatus == RequestsStatus.loading ? null : onSubmit,
        child: Text(
          submissionStatus == RequestsStatus.loading
              ? LocaleKeys.categories_form_fields_saving.tr()
              : isEditing
              ? LocaleKeys.expenses_buttons_update.tr()
              : LocaleKeys.expenses_buttons_save.tr(),
        ),
      ),
    );
  }
}
