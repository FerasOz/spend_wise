import '../entities/budget.dart';

abstract class BudgetRepository {
  Future<void> createBudget(Budget budget);

  Future<List<Budget>> getBudgets();

  Future<void> updateBudget(Budget budget);

  Future<void> deleteBudget(String id);
}
