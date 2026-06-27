import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';
import '../../../../../core/base/requests_status.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../features/categories/domain/entities/category.dart';
import '../../../domain/entities/recurring_expense.dart';
import 'recurring_expense_category_section.dart';
import 'recurring_expense_due_date_tile.dart';
import 'recurring_expense_repeat_section.dart';
import 'recurring_expense_text_fields.dart';

class RecurringExpenseFormContent extends StatelessWidget {
  const RecurringExpenseFormContent({
    required this.formKey,
    required this.title,
    required this.amountValue,
    required this.categories,
    required this.categoriesStatus,
    required this.selectedCategoryId,
    required this.repeatType,
    required this.dueDate,
    required this.submissionStatus,
    required this.isEditing,
    required this.onTitleSaved,
    required this.onAmountSaved,
    required this.onCategoryChanged,
    required this.onRepeatTypeChanged,
    required this.onDueDateChanged,
    required this.onSubmit,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final String? title;
  final String? amountValue;
  final List<Category> categories;
  final RequestsStatus categoriesStatus;
  final ValueNotifier<String?> selectedCategoryId;
  final ValueNotifier<RecurringRepeatType> repeatType;
  final ValueNotifier<DateTime> dueDate;
  final RequestsStatus submissionStatus;
  final bool isEditing;
  final ValueChanged<String?> onTitleSaved;
  final ValueChanged<String?> onAmountSaved;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<RecurringRepeatType> onRepeatTypeChanged;
  final ValueChanged<DateTime> onDueDateChanged;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.lg.w),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RecurringExpenseTextFields(
              title: title,
              amountValue: amountValue,
              onTitleSaved: onTitleSaved,
              onAmountSaved: onAmountSaved,
            ),
            SizedBox(height: AppSpacing.spacing20.h),
            RecurringExpenseCategorySection(
              categories: categories,
              categoriesStatus: categoriesStatus,
              selectedCategoryId: selectedCategoryId,
              onCategoryChanged: onCategoryChanged,
            ),
            SizedBox(height: AppSpacing.spacing20.h),
            RecurringExpenseRepeatSection(
              repeatType: repeatType,
              onRepeatTypeChanged: onRepeatTypeChanged,
            ),
            SizedBox(height: AppSpacing.lg.h),
            ValueListenableBuilder<DateTime>(
              valueListenable: dueDate,
              builder: (context, currentDueDate, _) =>
                  RecurringExpenseDueDateTile(
                    date: currentDueDate,
                    onDateChanged: onDueDateChanged,
                  ),
            ),
            SizedBox(height: AppSpacing.xxl.h),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: submissionStatus == RequestsStatus.loading
                    ? null
                    : onSubmit,
                icon: const Icon(Icons.check),
                label: Text(
                  isEditing
                      ? LocaleKeys.recurring_form_save.tr()
                      : LocaleKeys.recurring_form_create.tr(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
