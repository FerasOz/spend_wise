import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/base/requests_status.dart';
import '../../../../core/utils/category_resolver.dart';
import '../../../../core/widgets/category_picker.dart';
import '../../../../features/categories/domain/entities/category.dart';
import '../../../../features/categories/presentation/pages/category_list_page.dart';

class ExpenseCategoryField extends StatelessWidget {
  const ExpenseCategoryField({
    required this.categories,
    required this.categoriesStatus,
    required this.initialValue,
    required this.onSaved,
    required this.onCategorySelected,
    super.key,
  });

  final List<Category> categories;
  final RequestsStatus categoriesStatus;
  final String? initialValue;
  final ValueChanged<String?> onSaved;
  final ValueChanged<String?> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final displayCategories = _displayCategories;

    return FormField<String>(
      initialValue: initialValue,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Category is required.';
        }
        return null;
      },
      onSaved: onSaved,
      builder: (fieldState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategorySelector(
              categories: displayCategories,
              status: categoriesStatus,
              selectedCategoryId: fieldState.value,
              onCategorySelected: (category) {
                fieldState.didChange(category.id);
                onCategorySelected(category.id);
              },
              emptyStateMessage:
                  'No categories yet. Create one so every expense stays organized.',
              emptyStateActionLabel: 'Manage categories',
              onEmptyStateActionPressed: () =>
                  CategoryListPage.openCategoryManagementPage(context),
            ),
            if (fieldState.hasError)
              Padding(
                padding: EdgeInsets.only(top: 8.h, left: 12.w),
                child: Text(
                  fieldState.errorText ?? '',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12.sp,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  List<Category> get _displayCategories {
    final selectedCategoryId = initialValue;
    if (selectedCategoryId == null || selectedCategoryId.isEmpty) {
      return categories;
    }

    final hasSelectedCategory = categories.any(
      (category) => category.id == selectedCategoryId,
    );
    if (hasSelectedCategory) {
      return categories;
    }

    return [
      CategoryResolver.createFallbackCategory(selectedCategoryId),
      ...categories,
    ];
  }
}
