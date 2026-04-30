import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class AddExpense {
  const AddExpense(this._expenseRepository);

  final ExpenseRepository _expenseRepository;

  Future<void> call(Expense expense) {
    return _expenseRepository.addExpense(expense);
  }
}
