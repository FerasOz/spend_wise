import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_colors.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';
import 'package:spend_wise/core/widgets/category_badge.dart';
import 'package:spend_wise/features/budgets/domain/entities/budget_progress.dart';
import 'package:spend_wise/features/budgets/presentation/widgets/budget_list/budget_progress_bar.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

class DashboardBudgetAlerts extends StatelessWidget {
  const DashboardBudgetAlerts({
    required this.alerts,
    required this.categoriesById,
    super.key,
  });

  final List<BudgetProgress> alerts;
  final Map<String, Category> categoriesById;

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.budgets_alerts_title.tr(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: AppSpacing.md.h),
        ...alerts.map((alert) {
          final category = categoriesById[alert.budget.categoryId];
          if (category == null) {
            return const SizedBox.shrink();
          }

          final percent = (alert.progress * 100).clamp(0, 999).round();
          final isExceeded = alert.status == BudgetProgressStatus.exceeded;
          final accentColor = isExceeded ? AppColors.danger : const Color(0xFFF59E0B);
          final message = isExceeded
              ? LocaleKeys.budgets_alerts_exceeded.tr(
                  namedArgs: {'category': category.name},
                )
              : LocaleKeys.budgets_alerts_warning.tr(
                  namedArgs: {
                    'category': category.name,
                    'percent': '$percent',
                  },
                );

          return Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: AppSpacing.md.h),
            padding: EdgeInsets.all(AppSpacing.lg.w),
            decoration: BoxDecoration(
              color: accentColor.withAlpha(20),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: accentColor.withAlpha(80)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isExceeded ? Icons.error_outline : Icons.warning_amber_rounded,
                      color: accentColor,
                      size: 20.sp,
                    ),
                    SizedBox(width: AppSpacing.sm.w),
                    Expanded(
                      child: Text(
                        message,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.md.h),
                CategoryBadge(category: category),
                SizedBox(height: AppSpacing.md.h),
                BudgetProgressBar(
                  progress: alert.progress,
                  status: alert.status,
                ),
              ],
            ),
          );
        }),
        SizedBox(height: AppSpacing.xxl.h),
      ],
    );
  }
}
