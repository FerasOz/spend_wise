import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense.dart';
import 'package:spend_wise/features/expenses/presentation/cubit/expense_cubit.dart';
import 'package:spend_wise/features/expenses/presentation/cubit/expense_state.dart';
import 'package:spend_wise/features/expenses/presentation/widgets/expense_form.dart';
import 'package:spend_wise/features/expenses/presentation/widgets/expense_form_intro.dart';

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
    return BlocBuilder<ExpenseCubit, ExpenseState>(
      buildWhen: (previous, current) =>
          previous.selectedDate != current.selectedDate ||
          previous.submissionStatus != current.submissionStatus,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpenseFormIntro(isEditing: isEditing),
            ExpenseForm(
              selectedDate: state.selectedDate,
              submissionStatus: state.submissionStatus,
              initialExpense: expense,
              onDateSelected: context.read<ExpenseCubit>().setSelectedDate,
              onSubmit: (expenseData) {
                if (expense != null) {
                  return context.read<ExpenseCubit>().updateExpense(expenseData);
                }

                return context.read<ExpenseCubit>().addExpense(expenseData);
              },
            ),
          ],
        );
      },
    );
  }
}
