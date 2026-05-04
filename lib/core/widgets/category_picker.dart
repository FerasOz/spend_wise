import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/core/widgets/category_badge.dart';

typedef CategoryPickerCallback = void Function(Category category);

/// A reusable category picker widget that allows users to select a category
/// from an available list. Displays categories in a grid with visual feedback.
///
/// Used in expense creation/editing forms to replace manual text input.
class CategoryPicker extends StatelessWidget {
  const CategoryPicker({
    required this.categories,
    required this.onCategorySelected,
    this.selectedCategoryId,
    this.emptyStateMessage = 'No categories available',
    super.key,
  });

  /// List of available categories to display
  final List<Category> categories;

  /// Callback when a category is selected
  final CategoryPickerCallback onCategorySelected;

  /// ID of the currently selected category
  final String? selectedCategoryId;

  /// Message to show when no categories are available
  final String emptyStateMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (categories.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withAlpha(
            (0.3 * 255).round(),
          ),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 40.sp,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: 12.h),
            Text(
              emptyStateMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Category',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: 0.85,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = selectedCategoryId == category.id;

            return CategoryBadge(
              category: category,
              size: CategoryBadgeSize.large,
              isSelected: isSelected,
              onTap: () => onCategorySelected(category),
            );
          },
        ),
      ],
    );
  }
}
