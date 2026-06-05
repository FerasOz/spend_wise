import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/base/requests_status.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';
import '../../../domain/entities/expense.dart';
import '../../cubit/expense_cubit.dart';
import '../../cubit/expense_state.dart';
import 'expense_amount_field.dart';
import 'expense_note_field.dart';
import 'expense_submit_button.dart';
import 'expense_title_field.dart';
import 'expense_category_section.dart';
import 'expense_date_section.dart';

typedef SubmitExpenseCallback = Future<void> Function(Expense expense);

class ExpenseForm extends StatefulWidget {
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
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _title;
  String? _amount;
  String? _categoryId;
  String? _note;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpenseTitleField(
            initialValue: widget.initialExpense?.title ?? '',
            onSaved: (value) => _title = value,
          ),
          SizedBox(height: AppSpacing.md.h),
          ExpenseAmountField(
            initialValue: widget.initialExpense?.amount.toString() ?? '',
            onSaved: (value) => _amount = value,
          ),
          SizedBox(height: AppSpacing.md.h),
          ExpenseCategorySection(
            categories: widget.categories,
            categoriesStatus: widget.categoriesStatus,
            initialExpense: widget.initialExpense,
            onSaved: (value) => _categoryId = value,
            onCategorySelected: widget.onCategorySelected,
          ),
          SizedBox(height: AppSpacing.md.h),
          ExpenseDateSection(onDateSelected: widget.onDateSelected),
          SizedBox(height: AppSpacing.md.h),
          ExpenseNoteField(
            initialValue: widget.initialExpense?.note,
            onSaved: (value) => _note = value,
          ),
          SizedBox(height: AppSpacing.xxl.h),
          _ExpenseSubmitSection(isEditing: widget.initialExpense != null, onSubmit: _handleSubmit),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    _formKey.currentState?.save();
    final trimmedTitle = _title?.trim() ?? '';
    final trimmedAmount = _amount?.trim() ?? '';
    final trimmedCategoryId = _categoryId?.trim() ?? '';
    final amountValue = double.tryParse(trimmedAmount);

    if (trimmedTitle.isEmpty || trimmedAmount.isEmpty) {
      _showMessage(
        context,
        LocaleKeys.expenses_form_formErrors_titleAndAmountRequired.tr(),
      );
      return;
    }
    if (trimmedCategoryId.isEmpty) {
      _showMessage(
        context,
        LocaleKeys.expenses_form_formErrors_categoryRequired.tr(),
      );
      return;
    }
    if (amountValue == null || amountValue <= 0) {
      _showMessage(
        context,
        LocaleKeys.expenses_form_formErrors_amountValid.tr(),
      );
      return;
    }

    final savedExpense = Expense(
      id: widget.initialExpense != null
          ? widget.initialExpense!.id
          : DateTime.now().microsecondsSinceEpoch.toString(),
      title: trimmedTitle,
      amount: amountValue,
      categoryId: trimmedCategoryId,
      date: context.read<ExpenseCubit>().state.selectedDate,
      note: _note?.trim(),
      createdAt: widget.initialExpense?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await widget.onSubmit(savedExpense);
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
