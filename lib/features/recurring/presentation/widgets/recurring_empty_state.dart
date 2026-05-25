import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

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
              LocaleKeys.recurring_empty_title.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              LocaleKeys.recurring_empty_description.tr(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: AppSpacing.xxl.h),
            FilledButton.icon(
              onPressed: onAddRecurring,
              icon: const Icon(Icons.add),
              label: Text(LocaleKeys.recurring_empty_addBtn.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
