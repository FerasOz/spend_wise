import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

import '../../../../../core/widgets/currency_text.dart';
import '../../utils/category_expense_summary.dart';

class CategoryDetailsStats extends StatelessWidget {
  const CategoryDetailsStats({
    required this.summary,
    required this.color,
    super.key,
  });

  final CategoryExpenseSummary summary;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _CategoryStatCard.expenseCount(
            label: LocaleKeys.expenses_title.tr(),
            value: '${summary.expenseCount}',
            color: color,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _CategoryStatCard.totalSpent(
            label: LocaleKeys.categories_details_totalSpent.tr(),
            summary: summary,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _CategoryStatCard extends StatelessWidget {
  const _CategoryStatCard.expenseCount({
    required this.label,
    required this.value,
    required this.color,
  }) : summary = null;

  const _CategoryStatCard.totalSpent({
    required this.label,
    required this.summary,
    required this.color,
  }) : value = null;

  final String label;
  final String? value;
  final CategoryExpenseSummary? summary;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withAlpha(22),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          SizedBox(height: 6.h),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: value != null
                ? Text(
                    value!,
                    key: ValueKey(value),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : CurrencyText(
                    key: ValueKey(summary?.totalSpent ?? 0),
                    amount: summary!.totalSpent,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
