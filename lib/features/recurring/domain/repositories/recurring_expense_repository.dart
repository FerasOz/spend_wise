import '../entities/recurring_expense.dart';

abstract class RecurringExpenseRepository {
  Future<void> createRecurringExpense(RecurringExpense recurringExpense);

  Future<List<RecurringExpense>> getRecurringExpenses();

  Future<void> updateRecurringExpense(RecurringExpense recurringExpense);

  Future<void> deleteRecurringExpense(String id);
}
