import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../core/base/requests_status.dart';
import '../cubit/expense_cubit.dart';
import '../cubit/expense_state.dart';
import 'expenses_feedback_view.dart';
import 'expenses_list_view.dart';

class ExpensesStateView extends StatelessWidget {
  const ExpensesStateView({required this.state, super.key});

  final ExpenseState state;

  @override
  Widget build(BuildContext context) {
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
      return ExpensesFeedbackView(
        title: 'No expenses yet',
        message: 'Start tracking your spending by adding your first expense.',
        actionLabel: 'Add expense',
        onPressed: () => _openAddExpensePage(context),
      );
    }

    return ExpensesListView(expenses: state.expenses);
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
    context.read<ExpenseCubit>().resetExpenseForm();
    await Navigator.of(context).pushNamed(RouteNames.addExpensePage);
  }
}
