import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

class DashboardErrorState extends StatelessWidget {
  const DashboardErrorState({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 44.sp),
            SizedBox(height: AppSpacing.spacing14.h),
            Text(
              LocaleKeys.dashboard_errors_errorLoad.tr(),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(message, textAlign: TextAlign.center),
            SizedBox(height: AppSpacing.spacing18.h),
            FilledButton(
              onPressed: onRetry,
              child: Text(LocaleKeys.dashboard_errors_retryBtn.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
