import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/base/requests_status.dart';
import '../../../../features/categories/domain/entities/category.dart';
import '../../../../features/categories/presentation/utils/category_expense_summary.dart';
import '../../../../features/categories/presentation/widgets/category_details_expenses_section.dart';
import '../../../../features/categories/presentation/widgets/category_details_header.dart';
import '../../../../features/categories/presentation/widgets/category_details_stats.dart';
import '../../../../features/expenses/domain/entities/expense.dart';
import '../../../../features/expenses/presentation/cubit/expense_cubit.dart';
import '../../../../features/expenses/presentation/cubit/expense_state.dart';

class CategoryDetailsPage extends StatelessWidget {
  const CategoryDetailsPage({required this.category, super.key});

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Category Details')),
      body: BlocSelector<ExpenseCubit, ExpenseState, _CategoryDetailsData>(
        selector: (state) => _CategoryDetailsData.fromState(
          state: state,
          category: category,
        ),
        builder: (context, data) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
                  child: CategoryDetailsHeader(
                    category: category,
                    color: data.color,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  child: CategoryDetailsStats(
                    summary: data.summary,
                    color: data.color,
                  ),
                ),
              ),
              CategoryDetailsExpensesSection(
                category: category,
                expenses: data.expenses,
                expensesStatus: data.expensesStatus,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CategoryDetailsData {
  const _CategoryDetailsData({
    required this.color,
    required this.summary,
    required this.expensesStatus,
    required this.expenses,
  });

  factory _CategoryDetailsData.fromState({
    required ExpenseState state,
    required Category category,
  }) {
    final expenses = state.expenses
        .where((expense) => expense.categoryId == category.id)
        .toList(growable: false);

    return _CategoryDetailsData(
      color: Color(category.color),
      summary: CategoryExpenseSummary.buildByCategoryId(expenses)[category.id] ??
          CategoryExpenseSummary.empty,
      expensesStatus: state.expensesStatus,
      expenses: expenses,
    );
  }

  final Color color;
  final CategoryExpenseSummary summary;
  final RequestsStatus expensesStatus;
  final List<Expense> expenses;
}
