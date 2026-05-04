import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/category_picker.dart';
import '../../../../features/categories/domain/entities/category.dart';

class ExpenseCategoryField extends StatelessWidget {
  const ExpenseCategoryField({
    required this.categories,
    required this.initialValue,
    required this.onSaved,
    required this.onCategorySelected,
    super.key,
  });

  final List<Category> categories;
  final String? initialValue;
  final ValueChanged<String?> onSaved;
  final ValueChanged<String?> onCategorySelected;

  @override
  Widget build(BuildContext context) {
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
            CategoryPicker(
              categories: categories,
              selectedCategoryId: fieldState.value,
              onCategorySelected: (category) {
                fieldState.didChange(category.id);
                onCategorySelected(category.id);
              },
              emptyStateMessage:
                  'No categories available. Please create one first.',
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
}
