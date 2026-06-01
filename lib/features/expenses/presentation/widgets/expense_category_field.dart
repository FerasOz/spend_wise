import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';

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
    return FadeTransition(
      opacity: AlwaysStoppedAnimation(0.9),
      child: FormField<String>(
        initialValue: initialValue,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return LocaleKeys.expenses_form_fields_requiredCategory.tr();
          }
          return null;
        },
        onSaved: onSaved,
        builder: (fieldState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeTransition(
                opacity: AlwaysStoppedAnimation(0.95),
                child: CategorySelector(
                  categories: _displayCategories,
                  status: categoriesStatus,
                  selectedCategoryId: fieldState.value,
                  onCategorySelected: (category) {
                    fieldState.didChange(category.id);
                    onCategorySelected(category.id);
                  },
                  emptyStateMessage: LocaleKeys
                      .expenses_emptyCategory_createCategoryTxt
                      .tr(),
                  emptyStateActionLabel: LocaleKeys.expenses_emptyCategory_button
                      .tr(),
                  onEmptyStateActionPressed: () =>
                      CategoryListPage.openCategoryManagementPage(context),
                ),
              ),
              SizedBox(height: AppSpacing.sm.h),
              if (fieldState.hasError)
                Padding(
                  padding: EdgeInsets.only(left: AppSpacing.md.w),
                  child: Text(
                    fieldState.errorText ?? '',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
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
