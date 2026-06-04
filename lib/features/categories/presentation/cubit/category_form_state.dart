import 'package:spend_wise/core/base/requests_status.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';

class CategoryFormState {
  final RequestsStatus submissionStatus;
  final String categoryName;
  final String selectedIcon;
  final int selectedColor;
  final Category? editingCategory;
  final String? submissionErrorMessage;
  final int formVersion;

  const CategoryFormState({
    this.submissionStatus = RequestsStatus.initial,
    this.categoryName = '',
    this.selectedIcon = 'shopping_cart',
    this.selectedColor = 0xFFFF6B6B,
    this.editingCategory,
    this.submissionErrorMessage,
    this.formVersion = 0,
  });

  CategoryFormState copyWith({
    RequestsStatus? submissionStatus,
    String? categoryName,
    String? selectedIcon,
    int? selectedColor,
    Category? editingCategory,
    String? submissionErrorMessage,
    int? formVersion,
    bool clearEditingCategory = false,
    bool clearSubmissionErrorMessage = false,
  }) {
    return CategoryFormState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      categoryName: categoryName ?? this.categoryName,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      selectedColor: selectedColor ?? this.selectedColor,
      editingCategory: clearEditingCategory
          ? null
          : (editingCategory ?? this.editingCategory),
      submissionErrorMessage: clearSubmissionErrorMessage
          ? null
          : (submissionErrorMessage ?? this.submissionErrorMessage),
      formVersion: formVersion ?? this.formVersion,
    );
  }

  bool get isEditing => editingCategory != null;
}
