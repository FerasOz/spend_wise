import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../features/categories/domain/entities/category.dart';
import '../../../../features/categories/presentation/utils/category_presentation_data.dart';

class CategoryDetailsHeader extends StatelessWidget {
  const CategoryDetailsHeader({
    required this.category,
    required this.color,
    super.key,
  });

  final Category category;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        gradient: LinearGradient(
          colors: [color.withAlpha(230), color.withAlpha(170)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Hero(
            tag: 'category-icon-${category.id}',
            child: CircleAvatar(
              radius: 30.r,
              backgroundColor: Colors.white.withAlpha(38),
              child: Icon(
                CategoryPresentationData.iconFor(category.icon),
                color: Colors.white,
                size: 28.sp,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              category.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
