import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense.dart';
import 'package:spend_wise/features/expenses/presentation/cubit/expense_cubit.dart';
import 'package:spend_wise/features/expenses/presentation/cubit/expense_state.dart';
import 'package:spend_wise/features/expenses/presentation/widgets/expense_form.dart';
import 'package:spend_wise/features/expenses/presentation/widgets/expense_form_intro.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_cubit.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_state.dart';

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
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, categoryState) {
        return BlocBuilder<ExpenseCubit, ExpenseState>(
          buildWhen: (previous, current) =>
              previous.selectedDate != current.selectedDate ||
              previous.selectedCategoryId != current.selectedCategoryId ||
              previous.submissionStatus != current.submissionStatus,
          builder: (context, expenseState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpenseFormIntro(isEditing: isEditing),
                ExpenseForm(
                  categories: categoryState.categories,
                  selectedDate: expenseState.selectedDate,
                  submissionStatus: expenseState.submissionStatus,
                  selectedCategoryId:
                      expenseState.selectedCategoryId ?? expense?.categoryId,
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
        );
      },
    );
  }
}
