import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
