import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpenseFormIntro extends StatelessWidget {
  const ExpenseFormIntro({
    required this.isEditing,
    super.key,
  });

  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEditing ? 'Update your expense' : 'Track a new expense',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontSize: 24.sp),
        ),
        SizedBox(height: 8.h),
        Text(
          'Keep it simple for now. We can replace the category field with a picker once categories are built.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
        ),
      ],
    );
  }
}
