import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_spacing.dart';

class BudgetEmptyState extends StatelessWidget {
  const BudgetEmptyState({required this.onAddBudget, super.key});

  final VoidCallback onAddBudget;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxl.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.savings_outlined,
              size: 52.sp,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text('No budgets yet', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              'Create a category budget to stay ahead of your spending this month.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: AppSpacing.xxl.h),
            FilledButton.icon(
              onPressed: onAddBudget,
              icon: const Icon(Icons.add),
              label: const Text('Create budget'),
            ),
          ],
        ),
      ),
    );
  }
}
