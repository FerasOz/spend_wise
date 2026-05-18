import '../../domain/entities/budget.dart';
import '../../domain/repositories/budget_repository.dart';
import '../datasources/budget_local_data_source.dart';
import '../models/budget_model.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  const BudgetRepositoryImpl(this._localDataSource);

  final BudgetLocalDataSource _localDataSource;

  @override
  Future<void> createBudget(Budget budget) {
    return _localDataSource.createBudget(BudgetModel.fromEntity(budget));
  }

  @override
  Future<List<Budget>> getBudgets() async {
    final models = await _localDataSource.getBudgets();
    return models.map((model) => model.toEntity()).toList(growable: false);
  }

  @override
  Future<void> updateBudget(Budget budget) {
    return _localDataSource.updateBudget(BudgetModel.fromEntity(budget));
  }

  @override
  Future<void> deleteBudget(String id) {
    return _localDataSource.deleteBudget(id);
  }
}
