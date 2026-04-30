import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/base/requests_status.dart';
import '../../domain/entities/expense.dart';
import '../cubit/expense_cubit.dart';
import '../cubit/expense_state.dart';
import '../widgets/expense_form.dart';

class ExpenseFormPage extends StatelessWidget {
  const ExpenseFormPage({super.key, this.expense});

  final Expense? expense;

  @override
  Widget build(BuildContext context) {
    final isEditing = expense != null;

    return BlocListener<ExpenseCubit, ExpenseState>(
      listenWhen: (previous, current) =>
          previous.submissionStatus != current.submissionStatus,
      listener: (context, state) {
        if (state.submissionStatus == RequestsStatus.success) {
          Navigator.of(context).pop();
          return;
        }

        if (state.submissionStatus == RequestsStatus.error) {
          final errorMessage =
              state.submissionErrorMessage ?? 'Failed to save expense.';
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(errorMessage)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Edit Expense' : 'Add Expense'),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding = constraints.maxWidth >= 700
                  ? 24.w
                  : 16.w;

              return Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 720.w),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(horizontalPadding),
                    child: BlocBuilder<ExpenseCubit, ExpenseState>(
                      buildWhen: (previous, current) =>
                          previous.selectedDate != current.selectedDate ||
                          previous.submissionStatus != current.submissionStatus,
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEditing
                                  ? 'Update your expense'
                                  : 'Track a new expense',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontSize: 24.sp),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Keep it simple for now. We can replace the category field with a picker once categories are built.',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
                            ),
                            SizedBox(height: 24.h),
                            ExpenseForm(
                              selectedDate: state.selectedDate,
                              submissionStatus: state.submissionStatus,
                              initialExpense: expense,
                              onDateSelected: (date) {
                                context.read<ExpenseCubit>().setSelectedDate(
                                  date,
                                );
                              },
                              onSubmit: (expenseData) {
                                    if (expense != null) {
                                      return context
                                          .read<ExpenseCubit>()
                                          .updateExpense(expenseData);
                                    }

                                    return context
                                        .read<ExpenseCubit>()
                                        .addExpense(expenseData);
                                  },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
