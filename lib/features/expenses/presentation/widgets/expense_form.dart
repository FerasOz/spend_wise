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

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({
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

  final List<Category> categories;
  final DateTime selectedDate;
  final String? selectedCategoryId;
  final RequestsStatus submissionStatus;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<String?> onCategorySelected;
  final SubmitExpenseCallback onSubmit;
  final Expense? initialExpense;

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _title;
  String? _amount;
  String? _categoryId;
  String? _note;

  Future<void> _handleSubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    _formKey.currentState?.save();

    if ((_title?.trim().isEmpty ?? true) || (_amount?.trim().isEmpty ?? true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in title and amount.')),
      );
      return;
    }

    if ((_categoryId?.trim().isEmpty ?? true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category.')),
      );
      return;
    }

    final amountValue = double.tryParse(_amount!.trim());
    if (amountValue == null || amountValue <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount.')),
      );
      return;
    }

    final expense = Expense(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _title!.trim(),
      amount: amountValue,
      categoryId: _categoryId!.trim(),
      date: widget.selectedDate,
      note: _note?.trim(),
    );

    await widget.onSubmit(expense);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialExpense != null;
    final currentCategoryId =
        widget.selectedCategoryId ?? widget.initialExpense?.categoryId;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpenseTitleField(
            initialValue: widget.initialExpense?.title ?? '',
            onSaved: (value) => _title = value,
          ),
          SizedBox(height: 16.h),
          ExpenseAmountField(
            initialValue: widget.initialExpense?.amount.toString() ?? '',
            onSaved: (value) => _amount = value,
          ),
          SizedBox(height: 16.h),
          ExpenseCategoryField(
            categories: widget.categories,
            initialValue: currentCategoryId,
            onSaved: (value) => _categoryId = value,
            onCategorySelected: widget.onCategorySelected,
          ),
          SizedBox(height: 16.h),
          ExpenseDatePicker(
            selectedDate: widget.selectedDate,
            onDateSelected: widget.onDateSelected,
          ),
          SizedBox(height: 16.h),
          ExpenseNoteField(
            initialValue: widget.initialExpense?.note,
            onSaved: (value) => _note = value,
          ),
          SizedBox(height: 28.h),
          ExpenseSubmitButton(
            isEditing: isEditing,
            submissionStatus: widget.submissionStatus,
            onSubmit: _handleSubmit,
          ),
        ],
      ),
    );
  }
}
