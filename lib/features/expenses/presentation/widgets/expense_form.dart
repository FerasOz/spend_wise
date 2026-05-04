import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/base/requests_status.dart';
import '../../../../features/categories/domain/entities/category.dart';
import '../../domain/entities/expense.dart';
import 'expense_amount_field.dart';
import 'expense_category_field.dart';
import 'expense_date_picker.dart';
import 'expense_note_field.dart';
import 'expense_submit_button.dart';
import 'expense_title_field.dart';

typedef SubmitExpenseCallback = Future<void> Function(Expense expense);

class ExpenseForm extends StatelessWidget {
  ExpenseForm({
    required this.categories,
    required this.selectedDate,
    required this.selectedCategoryId,
    required this.submissionStatus,
    required this.onDateSelected,
    required this.onCategorySelected,
    required this.onSubmit,
    this.initialExpense,
    super.key,
  });

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<Category> categories;
  final DateTime selectedDate;
  final String? selectedCategoryId;
  final RequestsStatus submissionStatus;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<String?> onCategorySelected;
  final SubmitExpenseCallback onSubmit;
  final Expense? initialExpense;

  @override
  Widget build(BuildContext context) {
    final isEditing = initialExpense != null;
    String? currentCategoryId =
        selectedCategoryId ?? initialExpense?.categoryId;

    String? title;
    String? amount;
    String? note;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpenseTitleField(
            initialValue: initialExpense?.title ?? '',
            onSaved: (value) => title = value?.trim(),
          ),
          SizedBox(height: 16.h),
          ExpenseAmountField(
            initialValue: initialExpense?.amount.toString() ?? '',
            onSaved: (value) => amount = value?.trim(),
          ),
          SizedBox(height: 16.h),
          ExpenseCategoryField(
            categories: categories,
            initialValue: currentCategoryId,
            onSaved: (value) => currentCategoryId = value,
            onCategorySelected: onCategorySelected,
          ),
          SizedBox(height: 16.h),
          ExpenseDatePicker(
            selectedDate: selectedDate,
            onDateSelected: onDateSelected,
          ),
          SizedBox(height: 16.h),
          ExpenseNoteField(
            initialValue: initialExpense?.note,
            onSaved: (value) => note = value?.trim(),
          ),
          SizedBox(height: 28.h),
          ExpenseSubmitButton(
            formKey: _formKey,
            isEditing: isEditing,
            submissionStatus: submissionStatus,
            onSubmit: onSubmit,
            title: title ?? '',
            amount: amount ?? '0',
            categoryId: currentCategoryId ?? '',
            date: selectedDate,
            note: note,
          ),
        ],
      ),
    );
  }
}
