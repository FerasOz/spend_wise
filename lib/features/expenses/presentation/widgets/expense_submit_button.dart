import 'package:flutter/material.dart';

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
              ? 'Saving...'
              : isEditing
              ? 'Update expense'
              : 'Save expense',
        ),
      ),
    );
  }
}
