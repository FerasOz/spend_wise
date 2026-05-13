import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../features/categories/domain/entities/category.dart';
import '../../../../features/categories/presentation/cubit/category_cubit.dart';
import '../../domain/entities/expense.dart';
import '../pages/expense_details_page.dart';
import '../cubit/expense_cubit.dart';
import 'expense_item_actions.dart';
import 'expense_item_category_row.dart';
import 'expense_item_supporting.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({required this.expense, required this.category, super.key});

  final Expense expense;
  final Category category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        RouteNames.expenseDetailsPage,
        arguments: ExpenseDetailsRouteArgs(
          expense: expense,
          category: category,
          expenseCubit: context.read<ExpenseCubit>(),
          categoryCubit: context.read<CategoryCubit>(),
        ),
      ),
      borderRadius: BorderRadius.circular(24.r),
      child: Card(
        elevation: 2,
        color: theme.colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpenseLeadingAccent(color: Color(category.color)),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExpenseHeader(expense: expense),
                    SizedBox(height: 10.h),
                    ExpenseItemCategoryRow(
                      category: category,
                      trailing: ExpenseItemActions(expense: expense),
                    ),
                    if ((expense.note ?? '').trim().isNotEmpty) ...[
                      SizedBox(height: 12.h),
                      Text(
                        expense.note!.trim(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    SizedBox(height: 12.h),
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
