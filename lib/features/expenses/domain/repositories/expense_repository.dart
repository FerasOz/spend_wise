import '../entities/expense.dart';

abstract class ExpenseRepository {
  Future<void> addExpense(Expense expense);

  Future<List<Expense>> getExpenses();

  Future<List<Expense>> getLocalExpenses();

  Future<List<Expense>> getExpensesByCategoryId(String categoryId);

  Future<void> updateExpense(Expense expense);

  Future<void> deleteExpense(String id);
}
