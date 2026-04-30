import '../repositories/expense_repository.dart';

class DeleteExpense {
  const DeleteExpense(this._expenseRepository);

  final ExpenseRepository _expenseRepository;

  Future<void> call(String id) {
    return _expenseRepository.deleteExpense(id);
  }
}
