import '../entities/budget.dart';

abstract class BudgetRepository {
  Future<void> createBudget(Budget budget);

  Future<List<Budget>> getBudgets();

  Future<List<Budget>> getBudgetsByCategoryId(String categoryId);

  Future<void> updateBudget(Budget budget);

  Future<void> deleteBudget(String id);
}
