import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_state.dart';
import 'package:spend_wise/features/categories/presentation/utils/category_presentation_data.dart';

class CategoryPreviewCard extends StatelessWidget {
  const CategoryPreviewCard({
    required this.state,
    super.key,
  });

  final CategoryState state;

  @override
  Widget build(BuildContext context) {
    final displayName = state.categoryName.trim().isEmpty
        ? 'New Category'
        : state.categoryName.trim();

    return Center(
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: Color(state.selectedColor),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              CategoryPresentationData.iconFor(state.selectedIcon),
              color: Colors.white,
              size: 40.sp,
            ),
          ),
          SizedBox(height: 12.h),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Text(
              displayName,
              key: ValueKey(displayName),
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
