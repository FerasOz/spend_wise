import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/core/di/injection_container.dart';
import 'package:spend_wise/core/services/id_generator.dart';
import 'package:spend_wise/features/recurring/presentation/widgets/recurring_expense_form_content.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';
import '../../../categories/presentation/cubit/category_cubit.dart';
import '../../../expenses/presentation/cubit/expense_cubit.dart';
import '../../domain/entities/recurring_expense.dart';
import '../cubit/recurring_expense_cubit.dart';
import '../cubit/recurring_expense_state.dart';

class RecurringExpenseFormPage extends StatelessWidget {
  const RecurringExpenseFormPage({super.key, this.recurringExpense});

  final RecurringExpense? recurringExpense;

  static Future<void> open(
    BuildContext context, {
    RecurringExpense? recurringExpense,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => sl<RecurringExpenseCubit>()
                ..initializeForm(recurringExpense),
            ),
            BlocProvider(create: (_) => sl<CategoryCubit>()..loadCategories()),
            BlocProvider(create: (_) => sl<ExpenseCubit>()),
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
    final selectedCategoryId = ValueNotifier<String?>(
      recurringExpense?.categoryId,
    );
    final repeatType = ValueNotifier<RecurringRepeatType>(
      recurringExpense?.repeatType ?? RecurringRepeatType.monthly,
    );
    final dueDate = ValueNotifier<DateTime>(
      recurringExpense?.nextDueDate ?? context.read<ExpenseCubit>().now,
    );
    Future<void> submit() async {
      final isValid = formKey.currentState?.validate() ?? false;
      if (!isValid || selectedCategoryId.value == null) return;
      formKey.currentState?.save();

      final nextRecurringExpense = RecurringExpense(
        id:
            recurringExpense?.id ??
            sl<IdGenerator>().generate(),
        title: (title ?? '').trim(),
        amount: double.parse((amountValue ?? '').trim()),
        categoryId: selectedCategoryId.value!,
        repeatType: repeatType.value,
        nextDueDate: dueDate.value,
        isActive: recurringExpense?.isActive ?? true,
        createdAt: recurringExpense?.createdAt ?? context.read<ExpenseCubit>().now,
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
        title: Text(
          isEditing
              ? LocaleKeys.recurring_form_title_edit.tr()
              : LocaleKeys.recurring_form_title_add.tr(),
        ),
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
