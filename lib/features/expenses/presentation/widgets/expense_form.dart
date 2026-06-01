import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';
import '../../../../core/base/requests_status.dart';
import '../../../../features/categories/domain/entities/category.dart';
import '../../domain/entities/expense.dart';
import '../cubit/expense_cubit.dart';
import '../cubit/expense_state.dart';
import 'expense_amount_field.dart';
import 'expense_note_field.dart';
import 'expense_submit_button.dart';
import 'expense_title_field.dart';
import 'form/expense_category_section.dart';
import 'form/expense_date_section.dart';

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
        id: isEditing
            ? initialExpense!.id
            : DateTime.now().microsecondsSinceEpoch.toString(),
        title: trimmedTitle,
        amount: amountValue,
        categoryId: trimmedCategoryId,
        date: context.read<ExpenseCubit>().state.selectedDate,
        note: note?.trim(),
        createdAt: initialExpense?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await onSubmit(savedExpense);
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
          SizedBox(height: AppSpacing.md.h),
          ExpenseAmountField(
            initialValue: initialExpense?.amount.toString() ?? '',
            onSaved: (value) => amount = value,
          ),
          SizedBox(height: AppSpacing.md.h),
          ExpenseCategorySection(
            categories: categories,
            categoriesStatus: categoriesStatus,
            initialExpense: initialExpense,
            onSaved: (value) => categoryId = value,
            onCategorySelected: onCategorySelected,
          ),
          SizedBox(height: AppSpacing.md.h),
          ExpenseDateSection(onDateSelected: onDateSelected),
          SizedBox(height: AppSpacing.md.h),
          ExpenseNoteField(
            initialValue: initialExpense?.note,
            onSaved: (value) => note = value,
          ),
          SizedBox(height: AppSpacing.xxl.h),
          _ExpenseSubmitSection(isEditing: isEditing, onSubmit: handleSubmit),
        ],
      ),
    );
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
