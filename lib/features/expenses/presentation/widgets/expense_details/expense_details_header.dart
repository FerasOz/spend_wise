import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_radius.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';
import 'package:spend_wise/core/utils/app_formatters.dart';
import 'package:spend_wise/core/widgets/category_badge.dart';
import 'package:spend_wise/core/widgets/currency_text.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

class ExpenseDetailsHeader extends StatelessWidget {
  const ExpenseDetailsHeader({
    required this.expense,
    required this.category,
    super.key,
  });

  final Expense expense;
  final Category category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryColor = Color(category.color);

    return Container(
      padding: EdgeInsets.all(AppSpacing.spacing20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            categoryColor.withAlpha(220),
            theme.colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xxl.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.expenses_details_fields_amountSpent.tr(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          SizedBox(height: AppSpacing.sm.h),
          CurrencyText(
            amount: expense.amount,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: AppSpacing.lg.h),
          Wrap(
            spacing: AppSpacing.md.w,
            runSpacing: AppSpacing.md.h,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              CategoryBadge(category: category),
              _InfoPill(
                icon: Icons.schedule_outlined,
                label: AppFormatters.dateTime(expense.date),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: AppSpacing.sm.h,
      ),
      decoration: BoxDecoration(
        color: scheme.surface.withAlpha(150),
        borderRadius: BorderRadius.circular(AppRadius.pill.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: scheme.onSurface),
          SizedBox(width: AppSpacing.sm.w),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
