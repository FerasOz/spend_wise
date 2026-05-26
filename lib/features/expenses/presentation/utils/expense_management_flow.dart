import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

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
        ? LocaleKeys.expenses_messages_successDelete.tr()
        : (state.submissionErrorMessage ??
              LocaleKeys.expenses_messages_failedDelete.tr());

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));

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
          title: Text(LocaleKeys.expenses_management_delete_title.tr()),
          content: Text(LocaleKeys.expenses_management_delete_subTitle.tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(LocaleKeys.expenses_management_delete_cancel.tr()),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(LocaleKeys.expenses_management_delete_confirm.tr()),
            ),
          ],
        );
      },
    );
  }
}
