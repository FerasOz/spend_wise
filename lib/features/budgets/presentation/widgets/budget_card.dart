import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/currency_display_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/category_badge.dart';
import '../../../../features/categories/domain/entities/category.dart';
import '../../../../features/settings/domain/entities/app_currency.dart';
import '../../../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/budget_progress.dart';
import 'budget_form_page.dart';
import 'budget_progress_bar.dart';

class BudgetCard extends StatelessWidget {
  const BudgetCard({
    required this.budget,
    required this.category,
    required this.onDelete,
    super.key,
  });

  final BudgetProgress budget;
  final Category category;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayCurrency = context.select(
      (SettingsCubit cubit) =>
          cubit.state.settings?.currency ?? (throw StateError('Settings not loaded')),
    );
    final ratio =
        (budget.budget.limitAmount == 0
                ? 0
                : (budget.budget.spentAmount / budget.budget.limitAmount) * 100)
            .clamp(0, 999)
            .round();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: CategoryBadge(category: category)),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      BudgetFormPage.open(context, budget: budget.budget);
                      return;
                    }
                    onDelete();
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              _rangeLabel(displayCurrency),
              style: theme.textTheme.titleMedium,
            ),
            SizedBox(height: AppSpacing.spacing10.h),
            BudgetProgressBar(progress: budget.progress, status: budget.status),
            SizedBox(height: AppSpacing.md.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${CurrencyDisplayService.formatFromUsd(budget.budget.remainingAmount, displayCurrency)} remaining',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Text(
                  '$ratio%',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _rangeLabel(AppCurrency currency) {
    final spent = CurrencyDisplayService.formatFromUsd(
      budget.budget.spentAmount,
      currency,
    );
    final limit = CurrencyDisplayService.formatFromUsd(
      budget.budget.limitAmount,
      currency,
    );
    return '$spent of $limit';
  }
}
