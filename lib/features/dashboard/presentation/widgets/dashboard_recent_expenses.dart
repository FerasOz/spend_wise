import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';

import '../../../../features/categories/domain/entities/category.dart';
import '../../../../features/expenses/domain/entities/expense.dart';
import '../../../../features/expenses/presentation/widgets/expense_list_item.dart';
import 'dashboard_section_card.dart';
import 'dashboard_section_empty_state.dart';

class DashboardRecentExpenses extends StatelessWidget {
  const DashboardRecentExpenses({
    required this.expenses,
    required this.categoriesById,
    super.key,
  });

  final List<Expense> expenses;
  final Map<String, Category> categoriesById;

  @override
  Widget build(BuildContext context) {
    return DashboardSectionCard(
      title: 'Recent expenses',
      subtitle: 'Your latest transactions',
      child: expenses.isEmpty
          ? const DashboardSectionEmptyState(
              title: 'No recent expenses',
              message:
                  'Your latest expenses will appear here once you start tracking them.',
            )
          : Column(
              children: [
                for (var index = 0; index < expenses.length; index++) ...[
                  ExpenseItem(
                    expense: expenses[index],
                    category:
                        categoriesById[expenses[index].categoryId] ??
                        Category(
                          id: expenses[index].categoryId,
                          name: 'Unknown Category',
                          icon: 'shopping_cart',
                          color: 0xFFFF6B6B,
                          isDefault: false,
                          createdAt: expenses[index].date,
                        ),
                  ),
                  if (index != expenses.length - 1)
                    SizedBox(height: AppSpacing.md.h),
                ],
              ],
            ),
    );
  }
}
