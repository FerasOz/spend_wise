import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/base/requests_status.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense.dart';
import 'package:spend_wise/features/expenses/presentation/cubit/expense_cubit.dart';
import 'package:spend_wise/features/expenses/presentation/widgets/expense_form/expense_form_intro.dart';
import 'expense_form.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_cubit.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_state.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';

class ExpenseFormContent extends StatelessWidget {
  const ExpenseFormContent({
    required this.expense,
    required this.isEditing,
    super.key,
  });

  final Expense? expense;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: AlwaysStoppedAnimation(0.95),
      child: BlocSelector<
        CategoryCubit,
        CategoryState,
        ({List<Category> categories, RequestsStatus status})
      >(
        selector: (state) => (
          categories: state.categories,
          status: state.categoriesStatus,
        ),
        builder: (context, categoryView) {
          final sortedCategories = [...categoryView.categories]
            ..sort((first, second) => first.name.compareTo(second.name));
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeTransition(
                opacity: AlwaysStoppedAnimation(0.9),
                child: ExpenseFormIntro(isEditing: isEditing),
              ),
              SizedBox(height: AppSpacing.xxl.h),
              ExpenseForm(
                categories: sortedCategories,
                categoriesStatus: categoryView.status,
                initialExpense: expense,
                onDateSelected: context.read<ExpenseCubit>().setSelectedDate,
                onCategorySelected: context
                    .read<ExpenseCubit>()
                    .setSelectedCategoryId,
                onSubmit: (expenseData) {
                  if (expense != null) {
                    final updatedExpense = expenseData.copyWith(
                      id: expense!.id,
                    );
                    return context.read<ExpenseCubit>().updateExpense(
                      updatedExpense,
                    );
                  }

                  return context.read<ExpenseCubit>().addExpense(expenseData);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
