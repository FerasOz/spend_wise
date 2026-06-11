import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/features/recurring/presentation/extensions/recurring_repeat_type_extension.dart';
import 'package:spend_wise/features/recurring/presentation/pages/recurring_expense_form_page.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/app_formatters.dart';
import '../../../../../core/widgets/currency_text.dart';
import '../../../../../core/widgets/category_badge.dart';
import '../../../../../features/categories/domain/entities/category.dart';
import '../../../domain/entities/recurring_expense.dart';
import '../../cubit/recurring_expense_cubit.dart';

class RecurringExpenseTile extends StatelessWidget {
  const RecurringExpenseTile({
    required this.recurringExpense,
    required this.category,
    super.key,
  });

  final RecurringExpense recurringExpense;
  final Category category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      margin: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 80),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 20),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18.r),
          onTap: () {
            RecurringExpenseFormPage.open(
              context,
              recurringExpense: recurringExpense,
            );
          },
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.lg.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _RecurringExpenseContent(
                    item: recurringExpense,
                    category: category,
                  ),
                ),
                SizedBox(width: AppSpacing.md.w),
                _RecurringExpenseActions(item: recurringExpense),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecurringExpenseContent extends StatelessWidget {
  const _RecurringExpenseContent({required this.item, required this.category});

  final RecurringExpense item;
  final Category category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.title, style: theme.textTheme.titleMedium),
        SizedBox(height: AppSpacing.sm.h),
        CategoryBadge(category: category, size: CategoryBadgeSize.small),
        SizedBox(height: AppSpacing.sm.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CurrencyText(
              amount: item.amount,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: AppSpacing.sm.w),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm.w,
                vertical: AppSpacing.xs.h,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                item.repeatType.localizedName,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.xs.h),
        Text(
          '${LocaleKeys.recurring_details_nextDueDate.tr()}: ${AppFormatters.shortDate(item.nextDueDate)}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _RecurringExpenseActions extends StatelessWidget {
  const _RecurringExpenseActions({required this.item});

  final RecurringExpense item;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.sm.w,
            vertical: AppSpacing.xs.h,
          ),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14.r)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Switch(
                value: item.isActive,
                onChanged: (value) {
                  context.read<RecurringExpenseCubit>().toggleActive(
                    item,
                    value,
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.sm.h),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              RecurringExpenseFormPage.open(context, recurringExpense: item);
              return;
            }

            context.read<RecurringExpenseCubit>().deleteRecurringExpense(
              item.id,
            );
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'edit',
              child: Text(LocaleKeys.common_actions_edit.tr()),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text(LocaleKeys.common_actions_delete.tr()),
            ),
          ],
        ),
      ],
    );
  }
}
