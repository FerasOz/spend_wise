import '../entities/recurring_expense.dart';
import '../repositories/recurring_expense_repository.dart';

class CreateRecurringExpense {
  const CreateRecurringExpense(this._repository);

  final RecurringExpenseRepository _repository;

  Future<void> call(RecurringExpense recurringExpense) {
    return _repository.createRecurringExpense(recurringExpense);
  }
}
