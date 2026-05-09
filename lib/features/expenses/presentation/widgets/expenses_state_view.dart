import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/base/requests_status.dart';
import '../../../../features/categories/domain/entities/category.dart';
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
    return BlocSelector<
      CategoryCubit,
      CategoryState,
      ({List<Category> categories, RequestsStatus status})
    >(
      selector: (categoryState) => (
        categories: categoryState.categories,
        status: categoryState.categoriesStatus,
      ),
      builder: (context, categoryView) {
        if (_isInitialLoading) {
          return Center(
            child: SizedBox(
              height: 72.h,
              width: 72.h,
              child: const CircularProgressIndicator(),
            ),
          );
        }

        if (_hasInitialLoadError) {
          return ExpensesFeedbackView(
            title: 'Could not load expenses',
            message:
                state.loadErrorMessage ?? 'Something went wrong. Please try again.',
            actionLabel: 'Retry',
            onPressed: context.read<ExpenseCubit>().loadExpenses,
          );
        }

        if (state.expenses.isEmpty) {
          return _buildEmptyState(context, categoryView);
        }

        return ExpensesListView(
          expenses: state.expenses,
          categories: categoryView.categories,
        );
      },
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    ({List<Category> categories, RequestsStatus status}) categoryView,
  ) {
    if (categoryView.status == RequestsStatus.loading &&
        categoryView.categories.isEmpty) {
      return Center(
        child: SizedBox(
          height: 72.h,
          width: 72.h,
          child: const CircularProgressIndicator(),
        ),
      );
    }

    if (categoryView.categories.isEmpty) {
      return ExpensesFeedbackView(
        title: 'Create a category first',
        message:
            'Expenses are organized by category now. Add at least one category to start tracking spending.',
        actionLabel: 'Manage categories',
        onPressed: () => CategoryListPage.openCategoryManagementPage(context),
      );
    }

    return ExpensesFeedbackView(
      title: 'No expenses yet',
      message: 'Start tracking your spending by adding your first expense.',
      actionLabel: 'Add expense',
      onPressed: () => _openAddExpensePage(context),
    );
  }

  bool get _isInitialLoading {
    return state.expensesStatus == RequestsStatus.loading &&
        state.expenses.isEmpty;
  }

  bool get _hasInitialLoadError {
    return state.expensesStatus == RequestsStatus.error &&
        state.expenses.isEmpty;
  }

  Future<void> _openAddExpensePage(BuildContext context) async {
    await ExpensesPage.openExpenseFormPage(context);
  }
}
