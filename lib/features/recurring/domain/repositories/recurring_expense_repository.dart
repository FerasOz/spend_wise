import '../entities/recurring_expense.dart';

abstract class RecurringExpenseRepository {
  Future<void> createRecurringExpense(RecurringExpense recurringExpense);

  Future<List<RecurringExpense>> getRecurringExpenses();

  Future<List<RecurringExpense>> getRecurringExpensesByCategoryId(String categoryId);

  Future<void> updateRecurringExpense(RecurringExpense recurringExpense);

  Future<void> deleteRecurringExpense(String id);
}
