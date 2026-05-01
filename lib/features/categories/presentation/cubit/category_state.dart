import 'package:spend_wise/core/base/requests_status.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';

class CategoryState {
  final RequestsStatus categoriesStatus;
  final RequestsStatus submissionStatus;
  final RequestsStatus deletionStatus;
  final List<Category> categories;
  final String categoryName;
  final String selectedIcon;
  final int selectedColor;
  final Category? editingCategory;
  final String? loadErrorMessage;
  final String? submissionErrorMessage;
  final String? deletionErrorMessage;
  final String? userMessage;
  final int formVersion;

  const CategoryState({
    this.categoriesStatus = RequestsStatus.initial,
    this.submissionStatus = RequestsStatus.initial,
    this.deletionStatus = RequestsStatus.initial,
    this.categories = const [],
    this.categoryName = '',
    this.selectedIcon = 'shopping_cart',
    this.selectedColor = 0xFFFF6B6B,
    this.editingCategory,
    this.loadErrorMessage,
    this.submissionErrorMessage,
    this.deletionErrorMessage,
    this.userMessage,
    this.formVersion = 0,
  });

  CategoryState copyWith({
    RequestsStatus? categoriesStatus,
    RequestsStatus? submissionStatus,
    RequestsStatus? deletionStatus,
    List<Category>? categories,
    String? categoryName,
    String? selectedIcon,
    int? selectedColor,
    Category? editingCategory,
    String? loadErrorMessage,
    String? submissionErrorMessage,
    String? deletionErrorMessage,
    String? userMessage,
    int? formVersion,
    bool clearEditingCategory = false,
    bool clearLoadErrorMessage = false,
    bool clearSubmissionErrorMessage = false,
    bool clearDeletionErrorMessage = false,
    bool clearUserMessage = false,
  }) {
    return CategoryState(
      categoriesStatus: categoriesStatus ?? this.categoriesStatus,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      deletionStatus: deletionStatus ?? this.deletionStatus,
      categories: categories ?? this.categories,
      categoryName: categoryName ?? this.categoryName,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      selectedColor: selectedColor ?? this.selectedColor,
      editingCategory: clearEditingCategory
          ? null
          : (editingCategory ?? this.editingCategory),
      loadErrorMessage: clearLoadErrorMessage
          ? null
          : (loadErrorMessage ?? this.loadErrorMessage),
      submissionErrorMessage: clearSubmissionErrorMessage
          ? null
          : (submissionErrorMessage ?? this.submissionErrorMessage),
      deletionErrorMessage: clearDeletionErrorMessage
          ? null
          : (deletionErrorMessage ?? this.deletionErrorMessage),
      userMessage: clearUserMessage ? null : (userMessage ?? this.userMessage),
      formVersion: formVersion ?? this.formVersion,
    );
  }

  bool get isEditing => editingCategory != null;

  List<Category> get sortedCategories {
    final sorted = [...categories];
    sorted.sort((a, b) {
      if (a.isDefault && !b.isDefault) return -1;
      if (!a.isDefault && b.isDefault) return 1;
      return a.name.compareTo(b.name);
    });
    return sorted;
  }
}
