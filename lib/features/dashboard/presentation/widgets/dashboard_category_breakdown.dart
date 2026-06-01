import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';
import '../../../../core/widgets/currency_text.dart';
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
    return FadeTransition(
      opacity: AlwaysStoppedAnimation(0.95),
      child: DashboardSectionCard(
        title: LocaleKeys.dashboard_categoryBreakdown_title.tr(),
        subtitle: LocaleKeys.dashboard_categoryBreakdown_subTitle.tr(),
        child: categories.isEmpty
            ? DashboardSectionEmptyState(
                title: LocaleKeys.dashboard_categoryBreakdown_emptyTitle.tr(),
                message: LocaleKeys.dashboard_categoryBreakdown_emptyDescription
                    .tr(),
              )
            : FadeTransition(
                opacity: AlwaysStoppedAnimation(0.9),
                child: Column(
                  children: [
                    for (var index = 0; index < categories.length; index++) ...[
                      _CategoryBreakdownItem(
                        spending: categories[index],
                        onTap: () => onCategoryTap(categories[index]),
                      ),
                      if (index != categories.length - 1)
                        SizedBox(height: AppSpacing.spacing14.h),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}

class _CategoryBreakdownItem extends StatelessWidget {
  const _CategoryBreakdownItem({required this.spending, required this.onTap});

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
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xs.h),
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
                    spending.category.displayName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  percentageText,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.spacing10.h),
            LinearProgressIndicator(
              value: spending.percentage.clamp(0, 1),
              minHeight: AppSpacing.sm.h,
              borderRadius: BorderRadius.circular(999),
              backgroundColor: categoryColor.withAlpha(24),
              valueColor: AlwaysStoppedAnimation<Color>(categoryColor),
            ),
            SizedBox(height: AppSpacing.sm.h),
            CurrencyText(
              amount: spending.amount,
              style: Theme.of(context).textTheme.bodySmall,
              suffix: ' ${LocaleKeys.dashboard_categoryBreakdown_spent.tr()}',
            ),
          ],
        ),
      ),
    );
  }
}
