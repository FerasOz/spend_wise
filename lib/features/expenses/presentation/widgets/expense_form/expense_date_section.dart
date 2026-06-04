import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/expenses/presentation/cubit/expense_state.dart';
import 'package:spend_wise/features/expenses/presentation/widgets/expense_form/expense_date_picker.dart';
import '../../cubit/expense_cubit.dart';

class ExpenseDateSection extends StatefulWidget {
  const ExpenseDateSection({
    super.key,
    required this.onDateSelected,
  });

  final ValueChanged<DateTime> onDateSelected;

  @override
  State<ExpenseDateSection> createState() => _ExpenseDateSectionState();
}

class _ExpenseDateSectionState extends State<ExpenseDateSection> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ExpenseCubit, ExpenseState, DateTime>(
      selector: (state) => state.selectedDate,
      builder: (context, selectedDate) {
        return FadeTransition(
          opacity: const AlwaysStoppedAnimation(0.9),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              border: Border.all(
                color: _focusNode.hasFocus
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
                width: _focusNode.hasFocus ? 2.0 : 1.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ExpenseDatePicker(
              selectedDate: selectedDate,
              onDateSelected: widget.onDateSelected,
            ),
          ),
        );
      },
    );
  }
}
