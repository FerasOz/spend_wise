import 'package:flutter/material.dart';

import '../../domain/entities/expense.dart';
import '../pages/expenses_page.dart';
import '../utils/expense_management_flow.dart';

class ExpenseItemActions extends StatelessWidget {
  const ExpenseItemActions({required this.expense, super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) => _handleAction(context, value),
      itemBuilder: (_) => const [
        PopupMenuItem(value: 'edit', child: Text('Edit')),
        PopupMenuItem(value: 'delete', child: Text('Delete')),
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
