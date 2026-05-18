import '../entities/recurring_expense.dart';
import '../repositories/recurring_expense_repository.dart';

class GetRecurringExpenses {
  const GetRecurringExpenses(this._repository);

  final RecurringExpenseRepository _repository;

  Future<List<RecurringExpense>> call() {
    return _repository.getRecurringExpenses();
  }
}
