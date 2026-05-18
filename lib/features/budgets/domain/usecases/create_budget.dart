import '../entities/budget.dart';
import '../repositories/budget_repository.dart';

class CreateBudget {
  const CreateBudget(this._repository);

  final BudgetRepository _repository;

  Future<void> call(Budget budget) async {
    final existingBudgets = await _repository.getBudgets();
    final hasDuplicate = existingBudgets.any((existingBudget) {
      return existingBudget.categoryId == budget.categoryId &&
          existingBudget.period == budget.period;
    });

    if (hasDuplicate) {
      throw Exception('This category already has a budget for that period.');
    }

    return _repository.createBudget(budget);
  }
}
