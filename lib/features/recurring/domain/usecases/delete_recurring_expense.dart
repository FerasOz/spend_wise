import '../repositories/recurring_expense_repository.dart';

class DeleteRecurringExpense {
  const DeleteRecurringExpense(this._repository);

  final RecurringExpenseRepository _repository;

  Future<void> call(String id) {
    return _repository.deleteRecurringExpense(id);
  }
}
