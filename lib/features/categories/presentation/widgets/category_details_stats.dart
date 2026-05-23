import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/currency_text.dart';
import '../../../../features/categories/presentation/utils/category_expense_summary.dart';

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
            label: 'Expenses',
            value: '${summary.expenseCount}',
            color: color,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _CategoryStatCard.totalSpent(
            label: 'Total spent',
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
    required String label,
    required String value,
    required Color color,
  }) : label = label,
       value = value,
       summary = null,
       color = color;

  const _CategoryStatCard.totalSpent({
    required String label,
    required CategoryExpenseSummary summary,
    required Color color,
  }) : label = label,
       value = null,
       summary = summary,
       color = color;

  final String label;
  final String? value;
  final CategoryExpenseSummary? summary;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          if (value != null)
            Text(
              value!,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            )
          else if (summary != null)
            CurrencyText(
              amount: summary!.totalSpent,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}