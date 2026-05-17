import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/base/requests_status.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../features/categories/presentation/cubit/category_cubit.dart';
import '../../../../features/categories/presentation/cubit/category_state.dart';
import '../../../../features/categories/presentation/pages/category_list_page.dart';
import '../cubit/expense_cubit.dart';
import '../cubit/expense_state.dart';
import '../pages/expenses_page.dart';
import 'expenses_feedback_view.dart';
import 'expenses_list_view.dart';

class ExpensesStateView extends StatelessWidget {
  const ExpensesStateView({required this.state, super.key});

  final ExpenseState state;

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
            title: 'Could not load expenses',
            message: state.loadErrorMessage ?? 'Something went wrong. Please try again.',
            actionLabel: 'Retry',
            onPressed: context.read<ExpenseCubit>().loadExpenses,
          );
        }
        if (state.expenses.isEmpty) {
          return _ExpensesEmptyState(
            categoriesStatus: categoryState.categoriesStatus,
            hasCategories: categoryState.categories.isNotEmpty,
          );
        }
        if (state.visibleExpenses.isEmpty) {
          return ExpensesFeedbackView(
            title: 'No matching expenses',
            message: 'Try another search term or reset filters to find your expense.',
            actionLabel: 'Clear filters',
            onPressed: context.read<ExpenseCubit>().clearAllFilters,
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.hasActiveFilters)
              Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.md.h),
                child: Text(
                  '${state.visibleExpenses.length} expenses found',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            Expanded(
              child: ExpensesListView(
                expenses: state.visibleExpenses,
                categories: categoryState.categories,
              ),
            ),
          ],
        );
      },
    );
  }

  bool get _isInitialLoading {
    return state.expensesStatus == RequestsStatus.loading && state.expenses.isEmpty;
  }

  bool get _hasInitialError {
    return state.expensesStatus == RequestsStatus.error && state.expenses.isEmpty;
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
        title: 'Create a category first',
        message:
            'Expenses are organized by category. Add at least one category to start tracking spending.',
        actionLabel: 'Manage categories',
        onPressed: () => CategoryListPage.openCategoryManagementPage(context),
      );
    }

    return ExpensesFeedbackView(
      title: 'No expenses yet',
      message: 'Start tracking your spending by adding your first expense.',
      actionLabel: 'Add expense',
      onPressed: () => ExpensesPage.openExpenseFormPage(context),
    );
  }
}
