import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../categories/presentation/cubit/category_cubit.dart';
import '../../domain/entities/recurring_expense.dart';
import '../cubit/recurring_expense_cubit.dart';
import '../cubit/recurring_expense_state.dart';
import 'recurring_expense_form_content.dart';

class RecurringExpenseFormPage extends StatelessWidget {
  const RecurringExpenseFormPage({super.key, this.recurringExpense});

  final RecurringExpense? recurringExpense;

  static Future<void> open(
    BuildContext context, {
    RecurringExpense? recurringExpense,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<RecurringExpenseCubit>()),
            BlocProvider.value(value: context.read<CategoryCubit>()),
          ],
          child: RecurringExpenseFormPage(recurringExpense: recurringExpense),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final isEditing = recurringExpense != null;
    String? title = recurringExpense?.title;
    String? amountValue = recurringExpense?.amount.toString();
    final selectedCategoryId = ValueNotifier<String?>(recurringExpense?.categoryId);
    final repeatType = ValueNotifier<RecurringRepeatType>(
      recurringExpense?.repeatType ?? RecurringRepeatType.monthly,
    );
    final dueDate = ValueNotifier<DateTime>(
      recurringExpense?.nextDueDate ?? DateTime.now(),
    );
    Future<void> submit() async {
      final isValid = formKey.currentState?.validate() ?? false;
      if (!isValid || selectedCategoryId.value == null) return;
      formKey.currentState?.save();

      final nextRecurringExpense = RecurringExpense(
        id: recurringExpense?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        title: (title ?? '').trim(),
        amount: double.parse((amountValue ?? '').trim()),
        categoryId: selectedCategoryId.value!,
        repeatType: repeatType.value,
        nextDueDate: dueDate.value,
        isActive: recurringExpense?.isActive ?? true,
        createdAt: recurringExpense?.createdAt ?? DateTime.now(),
      );

      if (recurringExpense != null) {
        await context.read<RecurringExpenseCubit>().updateRecurringExpense(
          nextRecurringExpense,
        );
      } else {
        await context.read<RecurringExpenseCubit>().createRecurringExpense(
          nextRecurringExpense,
        );
      }
      if (context.mounted) Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit recurring expense' : 'Add recurring expense'),
      ),
      body: SafeArea(
        child: BlocBuilder<RecurringExpenseCubit, RecurringExpenseState>(
          buildWhen: (previous, current) =>
              previous.submissionStatus != current.submissionStatus,
          builder: (context, state) {
            final categories = context.select(
              (CategoryCubit cubit) => cubit.state.sortedCategories,
            );

            return RecurringExpenseFormContent(
              formKey: formKey,
              title: title,
              amountValue: amountValue,
              categories: categories,
              selectedCategoryId: selectedCategoryId,
              repeatType: repeatType,
              dueDate: dueDate,
              submissionStatus: state.submissionStatus,
              isEditing: isEditing,
              onTitleSaved: (value) => title = value,
              onAmountSaved: (value) => amountValue = value?.trim(),
              onCategoryChanged: (value) => selectedCategoryId.value = value,
              onRepeatTypeChanged: (value) => repeatType.value = value,
              onDueDateChanged: (value) => dueDate.value = value,
              onSubmit: submit,
            );
          },
        ),
      ),
    );
  }
}
