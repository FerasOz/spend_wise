import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/features/recurring/presentation/extensions/recurring_repeat_type_extension.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/currency_text.dart';
import '../../../../core/widgets/category_badge.dart';
import '../../../../features/categories/domain/entities/category.dart';
import '../../domain/entities/recurring_expense.dart';
import '../cubit/recurring_expense_cubit.dart';
import 'recurring_expense_form_page.dart';

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
    return Card(
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
          children: [
            CurrencyText(
              amount: item.amount,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(width: 4),
            Text(
              ' | ${item.repeatType.localizedName}',
              style: theme.textTheme.bodyMedium,
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
        Switch(
          value: item.isActive,
          onChanged: (value) {
            context.read<RecurringExpenseCubit>().toggleActive(item, value);
          },
        ),
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
