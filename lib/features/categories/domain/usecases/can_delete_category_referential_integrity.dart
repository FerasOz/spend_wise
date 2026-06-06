import 'package:spend_wise/features/categories/domain/repositories/category_repository.dart';
import 'package:spend_wise/features/expenses/domain/repositories/expense_repository.dart';
import 'package:spend_wise/features/budgets/domain/repositories/budget_repository.dart';
import 'package:spend_wise/features/recurring/domain/repositories/recurring_expense_repository.dart';

class CanDeleteCategoryReferentialIntegrity {
  const CanDeleteCategoryReferentialIntegrity(
    this._categoryRepository,
    this._expenseRepository,
    this._budgetRepository,
    this._recurringExpenseRepository,
  );

  final CategoryRepository _categoryRepository;
  final ExpenseRepository _expenseRepository;
  final BudgetRepository _budgetRepository;
  final RecurringExpenseRepository _recurringExpenseRepository;

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
    if (expenses.isNotEmpty) {
      return false;
    }

    // Check if any budgets reference this category
    final budgets = await _budgetRepository.getBudgetsByCategoryId(categoryId);
    if (budgets.isNotEmpty) {
      return false;
    }

    // Check if any recurring expenses reference this category
    final recurringExpenses = await _recurringExpenseRepository.getRecurringExpensesByCategoryId(categoryId);
    if (recurringExpenses.isNotEmpty) {
      return false;
    }

    return true;
  }
}