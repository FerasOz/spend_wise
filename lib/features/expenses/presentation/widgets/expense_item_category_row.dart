import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/category_badge.dart';
import '../../../../features/categories/domain/entities/category.dart';
import '../../../../features/categories/presentation/utils/category_presentation_data.dart';

class ExpenseItemCategoryRow extends StatelessWidget {
  const ExpenseItemCategoryRow({required this.category, required this.trailing, super.key});

  final Category category;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final color = Color(category.color);

    return Row(
      children: [
        Container(
          width: 52.w,
          height: 52.w,
          decoration: BoxDecoration(
            color: color.withAlpha((0.16 * 255).round()),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Icon(
            CategoryPresentationData.iconFor(category.icon),
            size: 26.sp,
            color: color,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: CategoryChip(category: category, size: CategoryBadgeSize.small),
        ),
        trailing,
      ],
    );
  }
}
