import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

class DashboardEmptyState extends StatelessWidget {
  const DashboardEmptyState({required this.onAddExpense, super.key});

  final VoidCallback onAddExpense;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: AlwaysStoppedAnimation(0.9),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xxl.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: AlwaysStoppedAnimation(0.8),
                child: Container(
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
              ),
              SizedBox(height: AppSpacing.xl.h),
              FadeTransition(
                opacity: AlwaysStoppedAnimation(0.9),
                child: Text(
                  LocaleKeys.dashboard_empty_title.tr(),
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: AppSpacing.spacing10.h),
              FadeTransition(
                opacity: AlwaysStoppedAnimation(0.9),
                child: Text(
                  LocaleKeys.dashboard_empty_subTitle.tr(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: AppSpacing.xxl.h),
              FadeTransition(
                opacity: AlwaysStoppedAnimation(0.9),
                child: FilledButton.icon(
                  onPressed: onAddExpense,
                  icon: const Icon(Icons.add),
                  label: Text(LocaleKeys.dashboard_empty_button.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
