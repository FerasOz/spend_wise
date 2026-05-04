import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/base/requests_status.dart';
import '../../domain/entities/expense.dart';

typedef SubmitExpenseCallback = Future<void> Function(Expense expense);

class ExpenseSubmitButton extends StatelessWidget {
  const ExpenseSubmitButton({
    required this.formKey,
    required this.isEditing,
    required this.submissionStatus,
    required this.onSubmit,
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.date,
    required this.note,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final bool isEditing;
  final RequestsStatus submissionStatus;
  final SubmitExpenseCallback onSubmit;
  final String title;
  final String amount;
  final String categoryId;
  final DateTime date;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: submissionStatus == RequestsStatus.loading
            ? null
            : () async {
                final isValid = formKey.currentState?.validate() ?? false;
                if (!isValid) {
                  return;
                }

                formKey.currentState?.save();

                final selectedId = categoryId;
                if (selectedId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a category.')),
                  );
                  return;
                }

                final expense = Expense(
                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                  title: title,
                  amount: double.parse(amount),
                  categoryId: selectedId,
                  date: date,
                  note: note?.isEmpty == true ? null : note,
                );

                await onSubmit(expense);
              },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          child: Text(
            submissionStatus == RequestsStatus.loading
                ? 'Saving...'
                : isEditing
                ? 'Update expense'
                : 'Save expense',
            style: TextStyle(fontSize: 15.sp),
          ),
        ),
      ),
    );
  }
}
