import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../features/categories/presentation/utils/category_presentation_data.dart';
import '../../domain/entities/category_spending.dart';
import 'dashboard_section_card.dart';
import 'dashboard_section_empty_state.dart';

class DashboardCategoryBreakdown extends StatelessWidget {
  const DashboardCategoryBreakdown({
    required this.categories,
    required this.onCategoryTap,
    super.key,
  });

  final List<CategorySpending> categories;
  final ValueChanged<CategorySpending> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return DashboardSectionCard(
      title: 'Category breakdown',
      subtitle: 'Where most of your money goes',
      child: categories.isEmpty
          ? const DashboardSectionEmptyState(
              title: 'No category activity',
              message:
                  'Category spending distribution will appear once you log expenses.',
            )
          : Column(
              children: [
                for (var index = 0; index < categories.length; index++) ...[
                  _CategoryBreakdownItem(
                    spending: categories[index],
                    onTap: () => onCategoryTap(categories[index]),
                  ),
                  if (index != categories.length - 1) SizedBox(height: 14.h),
                ],
              ],
            ),
    );
  }
}

class _CategoryBreakdownItem extends StatelessWidget {
  const _CategoryBreakdownItem({
    required this.spending,
    required this.onTap,
  });

  final CategorySpending spending;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final categoryColor = Color(spending.category.color);
    final percentageText = '${(spending.percentage * 100).round()}%';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42.w,
                  height: 42.w,
                  decoration: BoxDecoration(
                    color: categoryColor.withAlpha(24),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    CategoryPresentationData.iconFor(spending.category.icon),
                    color: categoryColor,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    spending.category.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  percentageText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            LinearProgressIndicator(
              value: spending.percentage.clamp(0, 1),
              minHeight: 8.h,
              borderRadius: BorderRadius.circular(999),
              backgroundColor: categoryColor.withAlpha(24),
              valueColor: AlwaysStoppedAnimation<Color>(categoryColor),
            ),
            SizedBox(height: 8.h),
            Text(
              '\$${spending.amount.toStringAsFixed(2)} spent',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
