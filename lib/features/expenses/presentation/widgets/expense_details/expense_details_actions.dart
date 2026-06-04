import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

class ExpenseDetailsActions extends StatelessWidget {
  const ExpenseDetailsActions({
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
            label: Text(LocaleKeys.common_actions_edit.tr()),
          ),
        ),
        SizedBox(width: AppSpacing.md.w),
        Expanded(
          child: FilledButton.icon(
            onPressed: onDelete,
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            icon: const Icon(Icons.delete_outline),
            label: Text(LocaleKeys.common_actions_delete.tr()),
          ),
        ),
      ],
    );
  }
}
