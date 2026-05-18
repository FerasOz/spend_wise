import '../../../expenses/domain/repositories/expense_repository.dart';
import '../entities/budget.dart';
import '../repositories/budget_repository.dart';

class GetBudgets {
  const GetBudgets(this._budgetRepository, this._expenseRepository);

  final BudgetRepository _budgetRepository;
  final ExpenseRepository _expenseRepository;

  Future<List<Budget>> call() async {
    final budgets = await _budgetRepository.getBudgets();
    final expenses = await _expenseRepository.getExpenses();
    final now = DateTime.now();

    return budgets.map((budget) {
      final spentAmount = expenses
          .where((expense) => expense.categoryId == budget.categoryId)
          .where((expense) => _matchesPeriod(expense.date, budget.period, now))
          .fold<double>(0, (total, expense) => total + expense.amount);

      return budget.copyWith(spentAmount: spentAmount);
    }).toList(growable: false);
  }

  bool _matchesPeriod(DateTime date, BudgetPeriod period, DateTime now) {
    switch (period) {
      case BudgetPeriod.monthly:
        return date.year == now.year && date.month == now.month;
      case BudgetPeriod.yearly:
        return date.year == now.year;
    }
  }
}
