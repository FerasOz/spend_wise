import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/expenses/presentation/widgets/expenses_list/expense_item_actions.dart';
import 'package:spend_wise/features/expenses/presentation/widgets/expenses_list/expense_item_category_row.dart';
import 'package:spend_wise/features/expenses/presentation/widgets/expenses_list/expense_item_supporting.dart';
import '../../../domain/entities/expense.dart';
import '../../pages/expense_details_page.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({required this.expense, required this.category, super.key});

  final Expense expense;
  final Category category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => ExpenseDetailsPage.open(context, expenseId: expense.id),
      borderRadius: BorderRadius.circular(24.r),
      child: Card(
        elevation: 2,
        color: theme.colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.lg.h,
            horizontal: AppSpacing.lg.w,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpenseLeadingAccent(color: Color(category.color)),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExpenseHeader(expense: expense),
                    SizedBox(height: AppSpacing.spacing10.h),
                    ExpenseItemCategoryRow(
                      category: category,
                      trailing: ExpenseItemActions(expense: expense),
                    ),
                    if ((expense.note ?? '').trim().isNotEmpty) ...[
                      SizedBox(height: AppSpacing.md.h),
                      Text(
                        expense.note!.trim(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    SizedBox(height: AppSpacing.md.h),
                    ExpenseDateLabel(date: expense.date),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
