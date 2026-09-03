import 'dart:async';

import '../../domain/entities/budget.dart';
import '../../domain/repositories/budget_repository.dart';
import '../datasources/budget_local_data_source.dart';
import '../datasources/budget_remote_data_source.dart';
import '../models/budget_model.dart';
import '../../../../core/services/sync_queue.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  const BudgetRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
    this._syncQueue,
  );

  final BudgetLocalDataSource _localDataSource;
  final BudgetRemoteDataSource _remoteDataSource;
  final SyncQueue _syncQueue;

  @override
  Future<void> createBudget(Budget budget) async {
    final model = BudgetModel.fromEntity(budget);
    await _localDataSource.createBudget(model);
    await _syncQueue.enqueueUpsert(
      table: 'budgets',
      entityId: model.id,
      payloadBuilder: model.toRemoteJson,
    );
    unawaited(_syncQueue.sync());
  }

  @override
  Future<List<Budget>> getBudgets() async {
    await _syncFromRemote();
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
    await _syncQueue.enqueueUpsert(
      table: 'budgets',
      entityId: model.id,
      payloadBuilder: model.toRemoteJson,
    );
    unawaited(_syncQueue.sync());
  }

  @override
  Future<void> deleteBudget(String id) async {
    await _localDataSource.deleteBudget(id);
    await _syncQueue.enqueueDelete(table: 'budgets', entityId: id);
    unawaited(_syncQueue.sync());
  }

  Future<void> _syncFromRemote() async {
    try {
      await _syncQueue.sync();
      final remoteBudgets = await _remoteDataSource.getBudgets();
      for (final budget in remoteBudgets) {
        await _localDataSource.createBudget(budget);
      }
    } catch (_) {
      // Offline fallback
    }
  }

  Future<void> _syncWrite(Future<void> Function() write) async {
    try {
      await write();
    } catch (_) {
      // Offline fallback
    }
  }
}
