import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          child: _CategoryStatCard(
            label: 'Expenses',
            value: '${summary.expenseCount}',
            color: color,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _CategoryStatCard(
            label: 'Total spent',
            value: '\$${summary.totalSpent.toStringAsFixed(2)}',
            color: color,
          ),
        ),
      ],
    );
  }
}

class _CategoryStatCard extends StatelessWidget {
  const _CategoryStatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
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
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
