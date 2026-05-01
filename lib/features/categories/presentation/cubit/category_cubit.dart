import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/core/base/requests_status.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/categories/domain/usecases/add_category.dart';
import 'package:spend_wise/features/categories/domain/usecases/can_delete_category.dart';
import 'package:spend_wise/features/categories/domain/usecases/delete_category.dart';
import 'package:spend_wise/features/categories/domain/usecases/get_categories.dart';
import 'package:spend_wise/features/categories/domain/usecases/update_category.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_state.dart';
import 'package:spend_wise/features/categories/presentation/utils/category_presentation_data.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit({
    required AddCategory addCategory,
    required GetCategories getCategories,
    required UpdateCategory updateCategory,
    required DeleteCategory deleteCategory,
    required CanDeleteCategory canDeleteCategory,
  }) : _addCategory = addCategory,
       _getCategories = getCategories,
       _updateCategory = updateCategory,
       _deleteCategory = deleteCategory,
       _canDeleteCategory = canDeleteCategory,
       super(const CategoryState());

  final AddCategory _addCategory;
  final GetCategories _getCategories;
  final UpdateCategory _updateCategory;
  final DeleteCategory _deleteCategory;
  final CanDeleteCategory _canDeleteCategory;

  void initializeForm([Category? category]) {
    final nextState = category == null
        ? state.copyWith(
            categoryName: '',
            selectedIcon: CategoryPresentationData.defaultIconName,
            selectedColor: CategoryPresentationData.defaultColorValue,
            submissionStatus: RequestsStatus.initial,
            formVersion: state.formVersion + 1,
            clearEditingCategory: true,
            clearSubmissionErrorMessage: true,
            clearUserMessage: true,
          )
        : state.copyWith(
            categoryName: category.name,
            selectedIcon: category.icon,
            selectedColor: category.color,
            editingCategory: category,
            submissionStatus: RequestsStatus.initial,
            formVersion: state.formVersion + 1,
            clearSubmissionErrorMessage: true,
            clearUserMessage: true,
          );

    emit(nextState);
  }

  void updateCategoryName(String value) {
    if (state.categoryName == value) {
      return;
    }

    emit(state.copyWith(categoryName: value));
  }

  void selectIcon(String iconName) {
    if (state.selectedIcon == iconName) {
      return;
    }

    emit(state.copyWith(selectedIcon: iconName));
  }

  void selectColor(int colorValue) {
    if (state.selectedColor == colorValue) {
      return;
    }

    emit(state.copyWith(selectedColor: colorValue));
  }

  Future<void> loadCategories() async {
    if (state.categoriesStatus == RequestsStatus.loading) {
      return;
    }

    emit(
      state.copyWith(
        categoriesStatus: RequestsStatus.loading,
        clearLoadErrorMessage: true,
      ),
    );

    try {
      final categories = await _getCategories();
      _emitLoadSuccess(categories);
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        state.copyWith(
          categoriesStatus: RequestsStatus.error,
          loadErrorMessage: _mapErrorToMessage(
            error,
            fallback: 'Failed to load categories.',
          ),
        ),
      );
    }
  }

  Future<void> submitCategory() async {
    final category = _buildCategoryFromState();
    if (category == null) {
      _emitSubmissionError('Unable to build category data.');
      return;
    }

    if (state.isEditing) {
      await _updateExistingCategory(category);
      return;
    }

    await _addNewCategory(category);
  }

  Future<void> deleteCategory(Category category) async {
    if (state.deletionStatus == RequestsStatus.loading) {
      return;
    }

    emit(
      state.copyWith(
        deletionStatus: RequestsStatus.loading,
        clearDeletionErrorMessage: true,
        clearUserMessage: true,
      ),
    );

    try {
      final canDelete = await _canDeleteCategory(category.id);
      if (!canDelete) {
        _emitDeletionError('Default categories cannot be deleted.');
        return;
      }

      await _deleteCategory(category.id);
      emit(
        state.copyWith(
          categories: _removeCategory(category.id),
          categoriesStatus: RequestsStatus.success,
          deletionStatus: RequestsStatus.success,
          userMessage: 'Category deleted successfully.',
          clearDeletionErrorMessage: true,
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      _emitDeletionError(
        _mapErrorToMessage(
          error,
          fallback: 'Failed to delete category.',
        ),
      );
    }
  }

  void clearMessages() {
    if (state.loadErrorMessage == null &&
        state.submissionErrorMessage == null &&
        state.deletionErrorMessage == null &&
        state.userMessage == null) {
      return;
    }

    emit(
      state.copyWith(
        clearLoadErrorMessage: true,
        clearSubmissionErrorMessage: true,
        clearDeletionErrorMessage: true,
        clearUserMessage: true,
      ),
    );
  }

  Future<void> _addNewCategory(Category category) async {
    await _performSubmission(
      action: () => _addCategory(category),
      onSuccess: () {
        emit(
          state.copyWith(
            categories: _appendCategory(category),
            categoriesStatus: RequestsStatus.success,
            submissionStatus: RequestsStatus.success,
            userMessage: 'Category added successfully.',
            clearSubmissionErrorMessage: true,
          ),
        );
      },
      fallbackErrorMessage: 'Failed to add category.',
    );
  }

  Future<void> _updateExistingCategory(Category category) async {
    await _performSubmission(
      action: () => _updateCategory(category),
      onSuccess: () {
        emit(
          state.copyWith(
            categories: _replaceCategory(category),
            categoriesStatus: RequestsStatus.success,
            submissionStatus: RequestsStatus.success,
            userMessage: 'Category updated successfully.',
            clearSubmissionErrorMessage: true,
          ),
        );
      },
      fallbackErrorMessage: 'Failed to update category.',
    );
  }

  Future<void> _performSubmission({
    required Future<void> Function() action,
    required void Function() onSuccess,
    required String fallbackErrorMessage,
  }) async {
    if (state.submissionStatus == RequestsStatus.loading) {
      return;
    }

    emit(
      state.copyWith(
        submissionStatus: RequestsStatus.loading,
        clearSubmissionErrorMessage: true,
        clearUserMessage: true,
      ),
    );

    try {
      await action();
      onSuccess();
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      _emitSubmissionError(
        _mapErrorToMessage(
          error,
          fallback: fallbackErrorMessage,
        ),
      );
    }
  }

  void _emitLoadSuccess(List<Category> categories) {
    final nextCategories = List<Category>.unmodifiable(categories);

    if (state.categoriesStatus == RequestsStatus.success &&
        _sameCategories(state.categories, nextCategories) &&
        state.loadErrorMessage == null) {
      return;
    }

    emit(
      state.copyWith(
        categoriesStatus: RequestsStatus.success,
        categories: nextCategories,
        clearLoadErrorMessage: true,
      ),
    );
  }

  void _emitSubmissionError(String message) {
    emit(
      state.copyWith(
        submissionStatus: RequestsStatus.error,
        submissionErrorMessage: message,
      ),
    );
  }

  void _emitDeletionError(String message) {
    emit(
      state.copyWith(
        deletionStatus: RequestsStatus.error,
        deletionErrorMessage: message,
      ),
    );
  }

  List<Category> _appendCategory(Category category) {
    return List<Category>.unmodifiable([...state.categories, category]);
  }

  List<Category> _replaceCategory(Category category) {
    return List<Category>.unmodifiable(
      state.categories.map((item) {
        return item.id == category.id ? category : item;
      }),
    );
  }

  List<Category> _removeCategory(String categoryId) {
    return List<Category>.unmodifiable(
      state.categories.where((item) => item.id != categoryId),
    );
  }

  bool _sameCategories(List<Category> first, List<Category> second) {
    if (identical(first, second)) {
      return true;
    }

    if (first.length != second.length) {
      return false;
    }

    for (var index = 0; index < first.length; index++) {
      if (first[index] != second[index]) {
        return false;
      }
    }

    return true;
  }

  Category? _buildCategoryFromState() {
    final trimmedName = state.categoryName.trim();
    if (trimmedName.isEmpty) {
      return null;
    }

    final editingCategory = state.editingCategory;
    if (editingCategory != null) {
      return editingCategory.copyWith(
        name: trimmedName,
        icon: state.selectedIcon,
        color: state.selectedColor,
      );
    }

    return Category(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: trimmedName,
      icon: state.selectedIcon,
      color: state.selectedColor,
      isDefault: false,
      createdAt: DateTime.now(),
    );
  }

  String _mapErrorToMessage(
    Object error, {
    required String fallback,
  }) {
    final message = error.toString().trim();
    if (message.isEmpty || message == 'Exception') {
      return fallback;
    }

    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }

    return message;
  }
}
