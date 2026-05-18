import '../entities/budget.dart';
import 'get_budgets.dart';

class GetBudgetByCategory {
  const GetBudgetByCategory(this._getBudgets);

  final GetBudgets _getBudgets;

  Future<Budget?> call(
    String categoryId, {
    BudgetPeriod period = BudgetPeriod.monthly,
  }) async {
    final budgets = await _getBudgets();

    for (final budget in budgets) {
      if (budget.categoryId == categoryId && budget.period == period) {
        return budget;
      }
    }

    return null;
  }
}
