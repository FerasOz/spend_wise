import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/core/base/requests_status.dart';
import 'package:spend_wise/features/expenses/presentation/cubit/expense_state.dart';
import '../../cubit/expense_cubit.dart';
import '../expense_submit_button.dart';

class ExpenseSubmitSection extends StatelessWidget {
  const ExpenseSubmitSection({
    super.key,
    required this.isEditing,
    required this.onSubmit,
  });

  final bool isEditing;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ExpenseCubit, ExpenseState, RequestsStatus>(
      selector: (state) => state.submissionStatus,
      builder: (context, submissionStatus) {
        return ExpenseSubmitButton(
          isEditing: isEditing,
          submissionStatus: submissionStatus,
          onSubmit: onSubmit,
        );
      },
    );
  }
}
