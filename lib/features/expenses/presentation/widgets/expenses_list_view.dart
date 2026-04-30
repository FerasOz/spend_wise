import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/expense.dart';
import '../cubit/expense_cubit.dart';
import 'expense_list_item.dart';

class ExpensesListView extends StatelessWidget {
  const ExpensesListView({required this.expenses, super.key});

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: context.read<ExpenseCubit>().loadExpenses,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: expenses.length,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          return ExpenseListItem(expense: expenses[index]);
        },
      ),
    );
  }
}
