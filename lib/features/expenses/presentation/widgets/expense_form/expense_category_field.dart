import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/base/requests_status.dart';
import 'package:spend_wise/core/utils/category_resolver.dart';
import 'package:spend_wise/core/widgets/category_picker.dart';
import 'package:spend_wise/features/categories/presentation/pages/category_list_page.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';

import '../../../../categories/domain/entities/category.dart' show Category;

class ExpenseCategoryField extends StatefulWidget {
  const ExpenseCategoryField({
    required this.categories,
    required this.categoriesStatus,
    required this.initialValue,
    required this.onSaved,
    required this.onCategorySelected,
    this.focusNode,
    super.key,
  });

  final List<Category> categories;
  final RequestsStatus categoriesStatus;
  final String? initialValue;
  final ValueChanged<String?> onSaved;
  final ValueChanged<String?> onCategorySelected;
  final FocusNode? focusNode;

  @override
  State<ExpenseCategoryField> createState() => _ExpenseCategoryFieldState();
}

class _ExpenseCategoryFieldState extends State<ExpenseCategoryField> {
  late final FocusNode _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: AlwaysStoppedAnimation(0.9),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: FormField<String>(
          initialValue: widget.initialValue,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return LocaleKeys.expenses_form_fields_requiredCategory.tr();
            }
            return null;
          },
          onSaved: widget.onSaved,
          builder: (fieldState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeTransition(
                  opacity: const AlwaysStoppedAnimation(0.95),
                  child: CategorySelector(
                    categories: _displayCategories,
                    status: widget.categoriesStatus,
                    selectedCategoryId: fieldState.value,
                    onCategorySelected: (category) {
                      fieldState.didChange(category.id);
                      widget.onCategorySelected(category.id);
                    },
                    emptyStateMessage: LocaleKeys
                        .expenses_emptyCategory_createCategoryTxt
                        .tr(),
                    emptyStateActionLabel: LocaleKeys
                        .expenses_emptyCategory_button
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
      ),
    );
  }

  List<Category> get _displayCategories {
    final selectedCategoryId = widget.initialValue;
    if (selectedCategoryId == null || selectedCategoryId.isEmpty) {
      return widget.categories;
    }

    final hasSelectedCategory = widget.categories.any(
      (category) => category.id == selectedCategoryId,
    );
    if (hasSelectedCategory) {
      return widget.categories;
    }

    return [
      CategoryResolver.createFallbackCategory(selectedCategoryId),
      ...widget.categories,
    ];
  }
}
