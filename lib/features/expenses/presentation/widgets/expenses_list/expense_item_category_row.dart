import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';
import 'package:spend_wise/core/widgets/category_badge.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/categories/presentation/utils/category_presentation_data.dart';

class ExpenseItemCategoryRow extends StatelessWidget {
  const ExpenseItemCategoryRow({
    required this.category,
    required this.trailing,
    super.key,
  });

  final Category category;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final color = Color(category.color);

    return FadeTransition(
      opacity: AlwaysStoppedAnimation(0.95),
      child: Row(
        children: [
          Container(
            width: AppSpacing.xxl.w,
            height: AppSpacing.xxl.w,
            decoration: BoxDecoration(
              color: color.withAlpha((0.16 * 255).round()),
              borderRadius: BorderRadius.circular(AppSpacing.lg.r),
            ),
            child: Icon(
              CategoryPresentationData.iconFor(category.icon),
              size: AppSpacing.lg.sp,
              color: color,
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: CategoryChip(
              category: category,
              size: CategoryBadgeSize.small,
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
