import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/base/requests_status.dart';
import '../../../../features/categories/domain/entities/category.dart';
import '../../domain/entities/expense.dart';
import '../cubit/expense_cubit.dart';
import '../cubit/expense_state.dart';
import 'expense_amount_field.dart';
import 'expense_category_field.dart';
import 'expense_date_picker.dart';
import 'expense_note_field.dart';
import 'expense_submit_button.dart';
import 'expense_title_field.dart';

typedef SubmitExpenseCallback = Future<void> Function(Expense expense);

class ExpenseForm extends StatelessWidget {
  const ExpenseForm({
    required this.categories,
    required this.categoriesStatus,
    required this.onDateSelected,
    required this.onCategorySelected,
    required this.onSubmit,
    this.initialExpense,
    super.key,
  });

  final List<Category> categories;
  final RequestsStatus categoriesStatus;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<String?> onCategorySelected;
  final SubmitExpenseCallback onSubmit;
  final Expense? initialExpense;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String? title;
    String? amount;
    String? categoryId;
    String? note;
    final isEditing = initialExpense != null;

    Future<void> handleSubmit() async {
      final isValid = formKey.currentState?.validate() ?? false;
      if (!isValid) return;

      formKey.currentState?.save();
      final trimmedTitle = title?.trim() ?? '';
      final trimmedAmount = amount?.trim() ?? '';
      final trimmedCategoryId = categoryId?.trim() ?? '';
      final amountValue = double.tryParse(trimmedAmount);

      if (trimmedTitle.isEmpty || trimmedAmount.isEmpty) {
        _showMessage(context, 'Please fill in title and amount.');
        return;
      }
      if (trimmedCategoryId.isEmpty) {
        _showMessage(context, 'Please select a category.');
        return;
      }
      if (amountValue == null || amountValue <= 0) {
        _showMessage(context, 'Please enter a valid amount.');
        return;
      }

      await onSubmit(
        Expense(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          title: trimmedTitle,
          amount: amountValue,
          categoryId: trimmedCategoryId,
          date: context.read<ExpenseCubit>().state.selectedDate,
          note: note?.trim(),
        ),
      );
    }

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpenseTitleField(
            initialValue: initialExpense?.title ?? '',
            onSaved: (value) => title = value,
          ),
          SizedBox(height: 16.h),
          ExpenseAmountField(
            initialValue: initialExpense?.amount.toString() ?? '',
            onSaved: (value) => amount = value,
          ),
          SizedBox(height: 16.h),
          _ExpenseCategorySection(
            categories: categories,
            categoriesStatus: categoriesStatus,
            initialExpense: initialExpense,
            onSaved: (value) => categoryId = value,
            onCategorySelected: onCategorySelected,
          ),
          SizedBox(height: 16.h),
          _ExpenseDateSection(onDateSelected: onDateSelected),
          SizedBox(height: 16.h),
          ExpenseNoteField(
            initialValue: initialExpense?.note,
            onSaved: (value) => note = value,
          ),
          SizedBox(height: 28.h),
          _ExpenseSubmitSection(
            isEditing: isEditing,
            onSubmit: handleSubmit,
          ),
        ],
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ExpenseCategorySection extends StatelessWidget {
  const _ExpenseCategorySection({
    required this.categories,
    required this.categoriesStatus,
    required this.initialExpense,
    required this.onSaved,
    required this.onCategorySelected,
  });

  final List<Category> categories;
  final RequestsStatus categoriesStatus;
  final Expense? initialExpense;
  final ValueChanged<String?> onSaved;
  final ValueChanged<String?> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ExpenseCubit, ExpenseState, String?>(
      selector: (state) => state.selectedCategoryId,
      builder: (context, selectedCategoryId) {
        return ExpenseCategoryField(
          categories: categories,
          categoriesStatus: categoriesStatus,
          initialValue: selectedCategoryId ?? initialExpense?.categoryId,
          onSaved: onSaved,
          onCategorySelected: onCategorySelected,
        );
      },
    );
  }
}

class _ExpenseDateSection extends StatelessWidget {
  const _ExpenseDateSection({required this.onDateSelected});

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

class _ExpenseSubmitSection extends StatelessWidget {
  const _ExpenseSubmitSection({
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
