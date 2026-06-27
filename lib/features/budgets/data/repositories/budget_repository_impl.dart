import 'dart:async';

import '../../domain/entities/budget.dart';
import '../../domain/repositories/budget_repository.dart';
import '../datasources/budget_local_data_source.dart';
import '../datasources/budget_remote_data_source.dart';
import '../models/budget_model.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  const BudgetRepositoryImpl(this._localDataSource, this._remoteDataSource);

  final BudgetLocalDataSource _localDataSource;
  final BudgetRemoteDataSource _remoteDataSource;

  @override
  Future<void> createBudget(Budget budget) async {
    final model = BudgetModel.fromEntity(budget);
    await _localDataSource.createBudget(model);
    try {
      await _remoteDataSource.createBudget(model);
    } catch (_) {
      // Offline fallback
    }
  }

  @override
  Future<List<Budget>> getBudgets() async {
    unawaited(_syncFromRemote());
    final models = await _localDataSource.getBudgets();
    return models.map((model) => model.toEntity()).toList(growable: false);
  }

  @override
  Future<List<Budget>> getBudgetsByCategoryId(String categoryId) async {
    final budgets = await getBudgets();
    return budgets
        .where((budget) => budget.categoryId == categoryId)
        .toList(growable: false);
  }

  @override
  Future<void> updateBudget(Budget budget) async {
    final model = BudgetModel.fromEntity(budget);
    await _localDataSource.updateBudget(model);
    try {
      await _remoteDataSource.updateBudget(model);
    } catch (_) {
      // Offline fallback
    }
  }

  @override
  Future<void> deleteBudget(String id) async {
    await _localDataSource.deleteBudget(id);
    try {
      await _remoteDataSource.deleteBudget(id);
    } catch (_) {
      // Offline fallback
    }
  }

  Future<void> _syncFromRemote() async {
    try {
      final remoteBudgets = await _remoteDataSource.getBudgets();
      for (final budget in remoteBudgets) {
        await _localDataSource.createBudget(budget);
      }
    } catch (_) {
      // Offline fallback
    }
  }
}
