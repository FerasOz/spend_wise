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
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxl.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.lg.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.repeat_outlined,
                size: 48.sp,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              LocaleKeys.recurring_empty_title.tr(),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              LocaleKeys.recurring_empty_description.tr(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
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
