import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

import '../../../../core/base/requests_status.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../features/categories/presentation/cubit/category_cubit.dart';
import '../../../../features/categories/presentation/cubit/category_state.dart';
import '../../../../features/categories/presentation/pages/category_list_page.dart';
import '../cubit/expense_cubit.dart';
import '../cubit/expense_filter_cubit.dart';
import '../cubit/expense_filter_state.dart';
import '../cubit/expense_state.dart';
import '../pages/expenses_page.dart';
import 'expenses_feedback_view.dart';
import 'expenses_list_view.dart';

class ExpensesStateView extends StatelessWidget {
  const ExpensesStateView({
    required this.expenseState,
    required this.filterState,
    super.key,
  });

  final ExpenseState expenseState;
  final ExpenseFilterState filterState;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CategoryCubit, CategoryState, CategoryState>(
      selector: (state) => state,
      builder: (context, categoryState) {
        if (_isInitialLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_hasInitialError) {
          return ExpensesFeedbackView(
            title: LocaleKeys.expenses_errorExpenses_title.tr(),
            message: LocaleKeys.expenses_errorExpenses_subTitle.tr(),
            actionLabel: LocaleKeys.expenses_errorExpenses_button.tr(),
            onPressed: context.read<ExpenseCubit>().loadExpenses,
          );
        }
        if (expenseState.expenses.isEmpty) {
          return _ExpensesEmptyState(
            categoriesStatus: categoryState.categoriesStatus,
            hasCategories: categoryState.categories.isNotEmpty,
          );
        }
        if (filterState.visibleExpenses.isEmpty) {
          return ExpensesFeedbackView(
            title: LocaleKeys.expenses_noMatchExpenses_title.tr(),
            message: LocaleKeys.expenses_noMatchExpenses_subTitle.tr(),
            actionLabel: LocaleKeys.expenses_noMatchExpenses_button.tr(),
            onPressed: context.read<ExpenseFilterCubit>().clearAll,
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (filterState.hasActiveFilters)
              Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.md.h),
                child: Text(
                  '${filterState.visibleExpenses.length} ${LocaleKeys.expenses_expensesFound.tr()}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            Expanded(
              child: ExpensesListView(
                expenses: filterState.visibleExpenses,
                categories: categoryState.categories,
              ),
            ),
          ],
        );
      },
    );
  }

  bool get _isInitialLoading {
    return expenseState.expensesStatus == RequestsStatus.loading &&
        expenseState.expenses.isEmpty;
  }

  bool get _hasInitialError {
    return expenseState.expensesStatus == RequestsStatus.error &&
        expenseState.expenses.isEmpty;
  }
}

class _ExpensesEmptyState extends StatelessWidget {
  const _ExpensesEmptyState({
    required this.categoriesStatus,
    required this.hasCategories,
  });

  final RequestsStatus categoriesStatus;
  final bool hasCategories;

  @override
  Widget build(BuildContext context) {
    if (categoriesStatus == RequestsStatus.loading && !hasCategories) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!hasCategories) {
      return ExpensesFeedbackView(
        title: LocaleKeys.expenses_emptyCategory_title.tr(),
        message: LocaleKeys.expenses_emptyCategory_subTitle.tr(),
        actionLabel: LocaleKeys.expenses_emptyCategory_button.tr(),
        onPressed: () => CategoryListPage.openCategoryManagementPage(context),
      );
    }

    return ExpensesFeedbackView(
      title: LocaleKeys.expenses_emptyExpenses_title.tr(),
      message: LocaleKeys.expenses_emptyExpenses_subTitle.tr(),
      actionLabel: LocaleKeys.expenses_emptyExpenses_button.tr(),
      onPressed: () => ExpensesPage.openExpenseFormPage(context),
    );
  }
}
