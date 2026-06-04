import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense.dart';
import 'package:spend_wise/features/expenses/presentation/pages/expenses_page.dart';
import 'package:spend_wise/features/expenses/presentation/utils/expense_management_flow.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

class ExpenseItemActions extends StatelessWidget {
  const ExpenseItemActions({required this.expense, super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) => _handleAction(context, value),
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'edit',
          child: Text(LocaleKeys.common_actions_edit.tr()),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Text(LocaleKeys.common_actions_delete.tr()),
        ),
      ],
      icon: Icon(
        Icons.more_vert,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  Future<void> _handleAction(BuildContext context, String action) async {
    if (action == 'edit') {
      await ExpensesPage.openExpenseFormPage(context, expense: expense);
      return;
    }

    await ExpenseManagementFlow.deleteExpense(context, expenseId: expense.id);
  }
}
