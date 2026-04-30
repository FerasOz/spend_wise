import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/base/requests_status.dart';
import '../../domain/entities/expense.dart';
import 'expense_date_picker.dart';
import 'expense_text_field.dart';

typedef SubmitExpenseCallback =
    Future<void> Function(Expense expense);

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({
    required this.selectedDate,
    required this.submissionStatus,
    required this.onDateSelected,
    required this.onSubmit,
    this.initialExpense,
    super.key,
  });

  final DateTime selectedDate;
  final RequestsStatus submissionStatus;
  final ValueChanged<DateTime> onDateSelected;
  final SubmitExpenseCallback onSubmit;
  final Expense? initialExpense;

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ExpenseForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialExpense != widget.initialExpense) {
      _initializeFields();
    }

    if (oldWidget.submissionStatus != RequestsStatus.success &&
        widget.submissionStatus == RequestsStatus.success) {
      _formKey.currentState?.reset();
      _titleController.clear();
      _amountController.clear();
      _categoryController.clear();
      _noteController.clear();
    }
  }

  void _initializeFields() {
    final initialExpense = widget.initialExpense;
    if (initialExpense == null) {
      return;
    }

    _titleController.text = initialExpense.title;
    _amountController.text = initialExpense.amount.toString();
    _categoryController.text = initialExpense.categoryId;
    _noteController.text = initialExpense.note ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialExpense != null;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpenseTextField(
            controller: _titleController,
            labelText: 'Title',
            hintText: 'Groceries',
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Title is required.';
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),
          ExpenseTextField(
            controller: _amountController,
            labelText: 'Amount',
            hintText: '24.99',
            prefixText: '\$ ',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            validator: (value) {
              final amount = double.tryParse(value?.trim() ?? '');
              if (amount == null || amount <= 0) {
                return 'Enter a valid amount.';
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),
          ExpenseTextField(
            controller: _categoryController,
            labelText: 'Category',
            hintText: 'Food',
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Category is required.';
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),
          ExpenseDatePicker(
            selectedDate: widget.selectedDate,
            onDateSelected: widget.onDateSelected,
          ),
          SizedBox(height: 16.h),
          ExpenseTextField(
            controller: _noteController,
            labelText: 'Note',
            hintText: 'Optional details',
            minLines: 3,
            maxLines: 5,
          ),
          SizedBox(height: 28.h),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: widget.submissionStatus == RequestsStatus.loading
                  ? null
                  : _submit,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                child: Text(
                  widget.submissionStatus == RequestsStatus.loading
                      ? 'Saving...'
                      : isEditing
                      ? 'Update expense'
                      : 'Save expense',
                  style: TextStyle(fontSize: 15.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final expense = Expense(
      id:
          widget.initialExpense?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      categoryId: _categoryController.text.trim(),
      date: widget.selectedDate,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );

    await widget.onSubmit(expense);
  }
}
