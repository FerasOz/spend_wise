import 'package:flutter/material.dart';

import '../../../../core/widgets/category_picker.dart';
import '../../../../features/categories/domain/entities/category.dart';

class RecurringExpenseCategorySection extends StatelessWidget {
  const RecurringExpenseCategorySection({
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategoryChanged,
    super.key,
  });

  final List<Category> categories;
  final ValueNotifier<String?> selectedCategoryId;
  final ValueChanged<String> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: selectedCategoryId,
      builder: (context, currentCategoryId, _) {
        return CategorySelector(
          categories: categories,
          selectedCategoryId: currentCategoryId,
          onCategorySelected: (category) => onCategoryChanged(category.id),
        );
      },
    );
  }
}
