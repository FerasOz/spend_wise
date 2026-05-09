import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/base/requests_status.dart';
import '../../../../features/categories/domain/entities/category.dart';
import '../../../../features/expenses/domain/entities/expense.dart';
import '../../../../features/expenses/presentation/widgets/expense_list_item.dart';

class CategoryDetailsExpensesSection extends StatelessWidget {
  const CategoryDetailsExpensesSection({
    required this.category,
    required this.expenses,
    required this.expensesStatus,
    super.key,
  });

  final Category category;
  final List<Expense> expenses;
  final RequestsStatus expensesStatus;

  @override
  Widget build(BuildContext context) {
    if (expensesStatus == RequestsStatus.loading && expenses.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (expensesStatus == RequestsStatus.error && expenses.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: _CategoryExpensesMessage(
          icon: Icons.error_outline,
          title: 'Could not load category expenses',
        ),
      );
    }

    if (expenses.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: _CategoryExpensesMessage(
          icon: Icons.receipt_long_outlined,
          title: 'No expenses in this category yet',
          message:
              'Once you assign expenses to this category, they will appear here.',
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: ExpenseItem(expense: expenses[index], category: category),
          );
        }, childCount: expenses.length),
      ),
    );
  }
}

class _CategoryExpensesMessage extends StatelessWidget {
  const _CategoryExpensesMessage({
    required this.icon,
    required this.title,
    this.message,
  });

  final IconData icon;
  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48.sp),
          SizedBox(height: 12.h),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          if (message != null) ...[
            SizedBox(height: 8.h),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
