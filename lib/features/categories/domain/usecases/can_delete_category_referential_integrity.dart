import 'package:spend_wise/features/categories/domain/repositories/category_repository.dart';
import 'package:spend_wise/features/expenses/domain/repositories/expense_repository.dart';

class CanDeleteCategoryReferentialIntegrity {
  const CanDeleteCategoryReferentialIntegrity(
    this._categoryRepository,
    this._expenseRepository,
  );

  final CategoryRepository _categoryRepository;
  final ExpenseRepository _expenseRepository;

  Future<bool> call(String categoryId) async {
    // First check if category exists and is not default
    final categories = await _categoryRepository.getCategories();
    final category = categories.where((c) => c.id == categoryId).firstOrNull;

    if (category == null) {
      return false;
    }

    if (category.isDefault) {
      return false;
    }

    // Check if any expenses reference this category
    final expenses = await _expenseRepository.getExpensesByCategoryId(categoryId);
    return expenses.isEmpty;
  }
}