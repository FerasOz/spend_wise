import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';

class DashboardSectionEmptyState extends StatelessWidget {
  const DashboardSectionEmptyState({
    required this.title,
    required this.message,
    super.key,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FadeTransition(
      opacity: AlwaysStoppedAnimation(0.95),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md.h),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg.w,
            vertical: AppSpacing.xl.h,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: FadeTransition(
            opacity: AlwaysStoppedAnimation(0.9),
            child: Column(
              children: [
                FadeTransition(
                  opacity: AlwaysStoppedAnimation(0.8),
                  child: Icon(
                    Icons.inbox_outlined,
                    size: 40.sp,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: (AppSpacing.sm + 2).h),
                FadeTransition(
                  opacity: AlwaysStoppedAnimation(0.9),
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: (AppSpacing.xs + 2).h),
                FadeTransition(
                  opacity: AlwaysStoppedAnimation(0.9),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
