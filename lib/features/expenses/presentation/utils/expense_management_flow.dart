import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/requests_status.dart';
import '../cubit/expense_cubit.dart';

class ExpenseManagementFlow {
  const ExpenseManagementFlow._();

  static Future<bool> deleteExpense(
    BuildContext context, {
    required String expenseId,
    VoidCallback? onDeleted,
  }) async {
    final confirmed = await _confirmDeletion(context);
    if (confirmed != true || !context.mounted) {
      return false;
    }

    await context.read<ExpenseCubit>().deleteExpense(expenseId);
    if (!context.mounted) {
      return false;
    }

    final state = context.read<ExpenseCubit>().state;
    final success = state.submissionStatus == RequestsStatus.success;
    final message = success
        ? 'Expense deleted successfully.'
        : (state.submissionErrorMessage ?? 'Failed to delete expense.');

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

    if (success) {
      onDeleted?.call();
    }

    return success;
  }

  static Future<bool?> _confirmDeletion(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete expense'),
          content: const Text(
            'This expense will be removed from your history. Continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
