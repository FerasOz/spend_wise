import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/base/requests_status.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_cubit.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_state.dart';
import 'package:spend_wise/features/categories/presentation/pages/category_list_page.dart';
import 'package:spend_wise/features/expenses/presentation/cubit/expense_cubit.dart';
import 'package:spend_wise/features/expenses/presentation/cubit/expense_filter_cubit.dart';
import 'package:spend_wise/features/expenses/presentation/cubit/expense_filter_state.dart';
import 'package:spend_wise/features/expenses/presentation/cubit/expense_state.dart';
import 'package:spend_wise/features/expenses/presentation/pages/expenses_page.dart';
import 'package:spend_wise/features/expenses/presentation/widgets/expenses_list/expenses_list_view.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';
import 'expenses_feedback_view.dart';

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
          return const FadeTransition(
            opacity: AlwaysStoppedAnimation(0.8),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (_hasInitialError) {
          return FadeTransition(
            opacity: const AlwaysStoppedAnimation(0.9),
            child: ExpensesFeedbackView(
              title: LocaleKeys.expenses_errorExpenses_title.tr(),
              message: LocaleKeys.expenses_errorExpenses_subTitle.tr(),
              actionLabel: LocaleKeys.expenses_errorExpenses_button.tr(),
              onPressed: context.read<ExpenseCubit>().loadExpenses,
            ),
          );
        }
        if (expenseState.expenses.isEmpty) {
          return FadeTransition(
            opacity: const AlwaysStoppedAnimation(0.9),
            child: _ExpensesEmptyState(
              categoriesStatus: categoryState.categoriesStatus,
              hasCategories: categoryState.categories.isNotEmpty,
            ),
          );
        }
        if (filterState.visibleExpenses.isEmpty) {
          return FadeTransition(
            opacity: const AlwaysStoppedAnimation(0.9),
            child: ExpensesFeedbackView(
              title: LocaleKeys.expenses_noMatchExpenses_title.tr(),
              message: LocaleKeys.expenses_noMatchExpenses_subTitle.tr(),
              actionLabel: LocaleKeys.expenses_noMatchExpenses_button.tr(),
              onPressed: context.read<ExpenseFilterCubit>().clearAll,
            ),
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
      return FadeTransition(
        opacity: const AlwaysStoppedAnimation(0.8),
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    if (!hasCategories) {
      return FadeTransition(
        opacity: const AlwaysStoppedAnimation(0.9),
        child: ExpensesFeedbackView(
          title: LocaleKeys.expenses_emptyCategory_title.tr(),
          message: LocaleKeys.expenses_emptyCategory_subTitle.tr(),
          actionLabel: LocaleKeys.expenses_emptyCategory_button.tr(),
          onPressed: () => CategoryListPage.openCategoryManagementPage(context),
        ),
      );
    }

    return FadeTransition(
      opacity: const AlwaysStoppedAnimation(0.9),
      child: ExpensesFeedbackView(
        title: LocaleKeys.expenses_emptyExpenses_title.tr(),
        message: LocaleKeys.expenses_emptyExpenses_subTitle.tr(),
        actionLabel: LocaleKeys.expenses_emptyExpenses_button.tr(),
        onPressed: () => ExpensesPage.openExpenseFormPage(context),
      ),
    );
  }
}
