import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpenseFormIntro extends StatelessWidget {
  const ExpenseFormIntro({required this.isEditing, super.key});

  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEditing ? 'Update your expense' : 'Track a new expense',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 8.h),
        Text(
          'Choose a category, capture the amount, and keep every expense tied to structured data you can trust later.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
