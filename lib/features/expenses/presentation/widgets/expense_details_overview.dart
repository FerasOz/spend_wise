import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../features/categories/domain/entities/category.dart';
import '../../domain/entities/expense.dart';

class ExpenseDetailsOverview extends StatelessWidget {
  const ExpenseDetailsOverview({
    required this.expense,
    required this.category,
    super.key,
  });

  final Expense expense;
  final Category category;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Title', style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: AppSpacing.sm.h),
        Text(
          expense.title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: AppSpacing.xxl.h),
        Text('Category', style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: AppSpacing.sm.h),
        Text(
          category.displayName,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
