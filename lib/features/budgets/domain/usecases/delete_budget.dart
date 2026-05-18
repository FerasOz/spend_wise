import '../repositories/budget_repository.dart';

class DeleteBudget {
  const DeleteBudget(this._repository);

  final BudgetRepository _repository;

  Future<void> call(String id) {
    return _repository.deleteBudget(id);
  }
}
