import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/categories/presentation/utils/category_presentation_data.dart';

/// A reusable widget that displays a category with its icon, color, and name.
/// Used in expense lists and category selection contexts.
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

  /// The category to display
  final Category category;

  /// Size variant for the badge
  final CategoryBadgeSize size;

  /// Whether to show the category name label
  final bool showLabel;

  /// Whether to show the icon
  final bool showIcon;

  /// Optional callback when badge is tapped
  final VoidCallback? onTap;

  /// Whether this badge is currently selected (for category pickers)
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
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: categoryColor.withAlpha((0.15 * 255).round()),
          borderRadius: BorderRadius.circular(8.r),
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
              SizedBox(width: 4.w),
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
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: categoryColor.withAlpha((0.12 * 255).round()),
          borderRadius: BorderRadius.circular(12.r),
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
            SizedBox(height: 8.h),
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

/// Size variants for the CategoryBadge widget
enum CategoryBadgeSize { small, medium, large }
