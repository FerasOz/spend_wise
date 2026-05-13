import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/base/requests_status.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/core/widgets/category_badge.dart';

typedef CategoryPickerCallback = void Function(Category category);

class CategorySelector extends StatelessWidget {
  const CategorySelector({
    required this.categories,
    required this.onCategorySelected,
    this.selectedCategoryId,
    this.emptyStateMessage = 'No categories available',
    this.emptyStateActionLabel,
    this.onEmptyStateActionPressed,
    this.status = RequestsStatus.success,
    super.key,
  });

  final List<Category> categories;
  final CategoryPickerCallback onCategorySelected;
  final String? selectedCategoryId;
  final String emptyStateMessage;
  final String? emptyStateActionLabel;
  final VoidCallback? onEmptyStateActionPressed;
  final RequestsStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sortedCategories = [...categories]
      ..sort((first, second) => first.name.compareTo(second.name));

    if (status == RequestsStatus.loading && categories.isEmpty) {
      return Container(
        padding: EdgeInsets.all(AppSpacing.xxl.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withAlpha(
            (0.3 * 255).round(),
          ),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (categories.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withAlpha(
            (0.3 * 255).round(),
          ),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        padding: EdgeInsets.all(AppSpacing.xxl.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 40.sp,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: AppSpacing.md.h),
            Text(
              emptyStateMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (emptyStateActionLabel != null &&
                onEmptyStateActionPressed != null) ...[
              SizedBox(height: AppSpacing.lg.h),
              OutlinedButton.icon(
                onPressed: onEmptyStateActionPressed,
                icon: const Icon(Icons.add_circle_outline),
                label: Text(emptyStateActionLabel!),
              ),
            ],
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
        SizedBox(height: AppSpacing.md.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: AppSpacing.md.h,
            crossAxisSpacing: AppSpacing.md.w,
            childAspectRatio: 0.85,
          ),
          itemCount: sortedCategories.length,
          itemBuilder: (context, index) {
            final category = sortedCategories[index];
            final isSelected = selectedCategoryId == category.id;

            return AnimatedScale(
              duration: const Duration(milliseconds: 180),
              scale: isSelected ? 1.0 : 0.96,
              child: CategoryChip(
                category: category,
                size: CategoryBadgeSize.large,
                isSelected: isSelected,
                onTap: () => onCategorySelected(category),
              ),
            );
          },
        ),
      ],
    );
  }
}

class CategoryPicker extends StatelessWidget {
  const CategoryPicker({
    required this.categories,
    required this.onCategorySelected,
    this.selectedCategoryId,
    this.emptyStateMessage = 'No categories available',
    super.key,
  });

  final List<Category> categories;
  final CategoryPickerCallback onCategorySelected;
  final String? selectedCategoryId;
  final String emptyStateMessage;

  @override
  Widget build(BuildContext context) {
    return CategorySelector(
      categories: categories,
      onCategorySelected: onCategorySelected,
      selectedCategoryId: selectedCategoryId,
      emptyStateMessage: emptyStateMessage,
    );
  }
}
