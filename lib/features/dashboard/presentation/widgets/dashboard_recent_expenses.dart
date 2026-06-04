import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';
import 'package:spend_wise/features/expenses/presentation/widgets/expenses_list/expense_list_item.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';
import '../../../../features/categories/domain/entities/category.dart';
import '../../../../features/expenses/domain/entities/expense.dart';
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
    return FadeTransition(
      opacity: AlwaysStoppedAnimation(0.95),
      child: DashboardSectionCard(
        title: LocaleKeys.dashboard_recentExpenses_title.tr(),
        subtitle: LocaleKeys.dashboard_recentExpenses_subTitle.tr(),
        child: expenses.isEmpty
            ? DashboardSectionEmptyState(
                title: LocaleKeys.dashboard_recentExpenses_emptyTitle.tr(),
                message: LocaleKeys.dashboard_recentExpenses_emptyDescription
                    .tr(),
              )
            : FadeTransition(
                opacity: AlwaysStoppedAnimation(0.9),
                child: Column(
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
                          createdAt: DateTime.fromMillisecondsSinceEpoch(0),
                            ),
                      ),
                      if (index != expenses.length - 1)
                        SizedBox(height: AppSpacing.md.h),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}
