import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_colors.dart';
import 'package:spend_wise/core/theme/app_radius.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';

class CategoryFeedbackView extends StatelessWidget {
  const CategoryFeedbackView({
    required this.icon,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxl.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppRadius.radius64.r, color: AppColors.grey),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              description,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.lg.h),
            ElevatedButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.refresh),
              label: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}
