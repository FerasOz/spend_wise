import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/requests_status.dart';
import '../../../../core/widgets/responsive_page_content.dart';
import '../../domain/entities/expense.dart';
import '../cubit/expense_cubit.dart';
import '../cubit/expense_state.dart';
import '../widgets/expense_form_content.dart';

class ExpenseFormPage extends StatelessWidget {
  const ExpenseFormPage({super.key, this.expense});

  final Expense? expense;

  @override
  Widget build(BuildContext context) {
    final isEditing = expense != null;

    // إذا كانت إضافة جديدة، أعد تعيين الـ form
    if (!isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ExpenseCubit>().resetExpenseForm();
      });
    }

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
          child: ResponsivePageContent(
            child: SingleChildScrollView(
              child: ExpenseFormContent(
                expense: expense,
                isEditing: isEditing,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
