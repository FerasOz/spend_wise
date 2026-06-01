import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/expenses/presentation/cubit/expense_state.dart';
import 'package:spend_wise/features/expenses/presentation/widgets/expense_date_picker.dart';
import '../../cubit/expense_cubit.dart';

class ExpenseDateSection extends StatelessWidget {
  const ExpenseDateSection({super.key, required this.onDateSelected});

  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ExpenseCubit, ExpenseState, DateTime>(
      selector: (state) => state.selectedDate,
      builder: (context, selectedDate) {
        return ExpenseDatePicker(
          selectedDate: selectedDate,
          onDateSelected: onDateSelected,
        );
      },
    );
  }
}
