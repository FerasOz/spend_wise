import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_spacing.dart';

class RecurringEmptyState extends StatelessWidget {
  const RecurringEmptyState({required this.onAddRecurring, super.key});

  final VoidCallback onAddRecurring;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxl.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.repeat_outlined,
              size: 52.sp,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              'No recurring expenses',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              'Track subscriptions and repeating bills so due expenses are generated automatically.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: AppSpacing.xxl.h),
            FilledButton.icon(
              onPressed: onAddRecurring,
              icon: const Icon(Icons.add),
              label: const Text('Add recurring expense'),
            ),
          ],
        ),
      ),
    );
  }
}
