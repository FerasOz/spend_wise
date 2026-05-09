import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/base/requests_status.dart';
import '../../../../features/categories/domain/entities/category.dart';
import '../../../../features/categories/presentation/utils/category_expense_summary.dart';
import '../../../../features/categories/presentation/utils/category_presentation_data.dart';
import '../../../../features/expenses/domain/entities/expense.dart';
import '../../../../features/expenses/presentation/cubit/expense_cubit.dart';
import '../../../../features/expenses/presentation/cubit/expense_state.dart';
import '../../../../features/expenses/presentation/widgets/expense_list_item.dart';

class CategoryDetailsPage extends StatelessWidget {
  const CategoryDetailsPage({required this.category, super.key});

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Category Details')),
      body: BlocSelector<ExpenseCubit, ExpenseState, _CategoryDetailsViewData>(
        selector: (state) => _CategoryDetailsViewData.fromState(
          state: state,
          category: category,
        ),
        builder: (context, viewData) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
                  child: _CategoryDetailsHeader(
                    category: category,
                    color: viewData.color,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  child: _CategoryDetailsStats(
                    summary: viewData.summary,
                    color: viewData.color,
                  ),
                ),
              ),
              viewData.contentSliver(category),
            ],
          );
        },
      ),
    );
  }
}

class _CategoryDetailsViewData {
  const _CategoryDetailsViewData({
    required this.color,
    required this.summary,
    required this.expensesStatus,
    required this.expenses,
  });

  factory _CategoryDetailsViewData.fromState({
    required ExpenseState state,
    required Category category,
  }) {
    final expenses = state.expenses
        .where((expense) => expense.categoryId == category.id)
        .toList(growable: false);

    return _CategoryDetailsViewData(
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

  Widget contentSliver(Category category) {
    if (expensesStatus == RequestsStatus.loading && expenses.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (expensesStatus == RequestsStatus.error && expenses.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: _CategoryExpensesErrorState(),
      );
    }

    if (expenses.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: _CategoryExpensesEmptyState(),
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

class _CategoryDetailsHeader extends StatelessWidget {
  const _CategoryDetailsHeader({
    required this.category,
    required this.color,
  });

  final Category category;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        gradient: LinearGradient(
          colors: [color.withAlpha(230), color.withAlpha(170)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Hero(
            tag: 'category-icon-${category.id}',
            child: CircleAvatar(
              radius: 30.r,
              backgroundColor: Colors.white.withAlpha(38),
              child: Icon(
                CategoryPresentationData.iconFor(category.icon),
                color: Colors.white,
                size: 28.sp,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              category.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryDetailsStats extends StatelessWidget {
  const _CategoryDetailsStats({
    required this.summary,
    required this.color,
  });

  final CategoryExpenseSummary summary;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _CategoryStatCard(
            label: 'Expenses',
            value: '${summary.expenseCount}',
            color: color,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _CategoryStatCard(
            label: 'Total spent',
            value: '\$${summary.totalSpent.toStringAsFixed(2)}',
            color: color,
          ),
        ),
      ],
    );
  }
}

class _CategoryStatCard extends StatelessWidget {
  const _CategoryStatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withAlpha(22),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          SizedBox(height: 6.h),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryExpensesEmptyState extends StatelessWidget {
  const _CategoryExpensesEmptyState();

  @override
  Widget build(BuildContext context) {
    return const _CategoryExpensesMessage(
      icon: Icons.receipt_long_outlined,
      title: 'No expenses in this category yet',
      message: 'Once you assign expenses to this category, they will appear here.',
    );
  }
}

class _CategoryExpensesErrorState extends StatelessWidget {
  const _CategoryExpensesErrorState();

  @override
  Widget build(BuildContext context) {
    return const _CategoryExpensesMessage(
      icon: Icons.error_outline,
      title: 'Could not load category expenses',
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
