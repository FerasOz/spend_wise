import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/features/budgets/presentation/pages/budget_form_page.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

import '../../../../core/services/currency_display_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/category_badge.dart';
import '../../../../features/categories/domain/entities/category.dart';
import '../../../../features/settings/domain/entities/app_currency.dart';
import '../../../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/budget_progress.dart';
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
          cubit.state.settings?.currency ??
          const AppCurrency(code: 'USD', symbol: '\$'),
    );
    final ratio =
        (budget.budget.limitAmount == 0
                ? 0
                : (budget.budget.spentAmount / budget.budget.limitAmount) * 100)
            .clamp(0, 999)
            .round();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.all(AppSpacing.lg.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withAlpha(80),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.light
                ? const Color(0x12000000)
                : theme.colorScheme.surface.withAlpha(38),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
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
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text(LocaleKeys.budgets_card_edit.tr()),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(LocaleKeys.budgets_card_delete.tr()),
                  ),
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
                  '${CurrencyDisplayService.formatFromUsd(budget.budget.remainingAmount, displayCurrency)} ${LocaleKeys.budgets_remaining.tr()}',
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
    return '$spent ${LocaleKeys.budgets_card_of.tr()} $limit';
  }
}
