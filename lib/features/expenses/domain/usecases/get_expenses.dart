import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class GetExpenses {
  const GetExpenses(this._expenseRepository);

  final ExpenseRepository _expenseRepository;

  Future<List<Expense>> call() {
    return _expenseRepository.getExpenses();
  }
}
