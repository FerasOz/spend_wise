import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';
import 'package:spend_wise/core/utils/app_formatters.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

class ExpenseDetailsMetadata extends StatelessWidget {
  const ExpenseDetailsMetadata({required this.expense, super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.expenses_details_fields_timeline.tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: AppSpacing.md.h),
            _MetadataRow(
              label: LocaleKeys.expenses_details_fields_created.tr(),
              value: AppFormatters.dateTimeOrFallback(expense.createdAt),
            ),
            SizedBox(height: AppSpacing.sm.h),
            _MetadataRow(
              label: LocaleKeys.expenses_details_fields_updated.tr(),
              value: AppFormatters.dateTimeOrFallback(expense.updatedAt),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetadataRow extends StatelessWidget {
  const _MetadataRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
