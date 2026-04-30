import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class UpdateExpense {
  const UpdateExpense(this._expenseRepository);

  final ExpenseRepository _expenseRepository;

  Future<void> call(Expense expense) {
    return _expenseRepository.updateExpense(expense);
  }
}
