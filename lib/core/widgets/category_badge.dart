import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/categories/presentation/utils/category_presentation_data.dart';
import 'package:spend_wise/core/theme/app_radius.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    required this.category,
    this.size = CategoryBadgeSize.medium,
    this.showLabel = true,
    this.showIcon = true,
    this.onTap,
    this.isSelected = false,
    super.key,
  });

  final Category category;
  final CategoryBadgeSize size;
  final bool showLabel;
  final bool showIcon;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryColor = Color(category.color);

    switch (size) {
      case CategoryBadgeSize.small:
        return _buildSmallBadge(context, theme, categoryColor);
      case CategoryBadgeSize.medium:
        return _buildMediumBadge(context, theme, categoryColor);
      case CategoryBadgeSize.large:
        return _buildLargeBadge(context, theme, categoryColor);
    }
  }

  Widget _buildSmallBadge(
    BuildContext context,
    ThemeData theme,
    Color categoryColor,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.sm.w,
          vertical: AppSpacing.xs.h,
        ),
        decoration: BoxDecoration(
          color: categoryColor.withAlpha((0.15 * 255).round()),
          borderRadius: BorderRadius.circular(AppRadius.sm.r),
          border: isSelected
              ? Border.all(color: categoryColor, width: 1.5.w)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) ...[
              Icon(
                CategoryPresentationData.iconFor(category.icon),
                size: 14.sp,
                color: categoryColor,
              ),
              SizedBox(width: AppSpacing.xs.w),
            ],
            if (showLabel)
              Text(
                category.name,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: categoryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediumBadge(
    BuildContext context,
    ThemeData theme,
    Color categoryColor,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md.w,
          vertical: AppSpacing.sm.h,
        ),
        decoration: BoxDecoration(
          color: categoryColor.withAlpha((0.12 * 255).round()),
          borderRadius: BorderRadius.circular(AppRadius.md.r),
          border: isSelected
              ? Border.all(color: categoryColor, width: 2.w)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) ...[
              Icon(
                CategoryPresentationData.iconFor(category.icon),
                size: 18.sp,
                color: categoryColor,
              ),
              SizedBox(width: 6.w),
            ],
            if (showLabel)
              Text(
                category.name,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: categoryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeBadge(
    BuildContext context,
    ThemeData theme,
    Color categoryColor,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: categoryColor.withAlpha((0.15 * 255).round()),
              border: isSelected
                  ? Border.all(color: categoryColor, width: 2.5.w)
                  : null,
            ),
            child: Icon(
              CategoryPresentationData.iconFor(category.icon),
              size: 32.sp,
              color: categoryColor,
            ),
          ),
          if (showLabel) ...[
            SizedBox(height: AppSpacing.sm.h),
            Text(
              category.name,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class CategoryBadge extends StatelessWidget {
  const CategoryBadge({
    required this.category,
    this.size = CategoryBadgeSize.medium,
    this.showLabel = true,
    this.showIcon = true,
    this.onTap,
    this.isSelected = false,
    super.key,
  });

  final Category category;
  final CategoryBadgeSize size;
  final bool showLabel;
  final bool showIcon;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return CategoryChip(
      category: category,
      size: size,
      showLabel: showLabel,
      showIcon: showIcon,
      onTap: onTap,
      isSelected: isSelected,
    );
  }
}

enum CategoryBadgeSize { small, medium, large }
