import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';

class DashboardEmptyState extends StatelessWidget {
  const DashboardEmptyState({required this.onAddExpense, super.key});

  final VoidCallback onAddExpense;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxl.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.xl.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.insights_outlined,
                size: 42.sp,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: AppSpacing.xl.h),
            Text(
              'Your dashboard starts with one expense',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.spacing10.h),
            Text(
              'Add your first expense to unlock spending summaries, weekly trends, and category insights.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.xxl.h),
            FilledButton.icon(
              onPressed: onAddExpense,
              icon: const Icon(Icons.add),
              label: const Text('Add your first expense'),
            ),
          ],
        ),
      ),
    );
  }
}
