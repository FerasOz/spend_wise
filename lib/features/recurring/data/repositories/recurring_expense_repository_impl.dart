import 'dart:async';

import '../../domain/entities/recurring_expense.dart';
import '../../domain/repositories/recurring_expense_repository.dart';
import '../datasources/recurring_expense_local_data_source.dart';
import '../datasources/recurring_expense_remote_data_source.dart';
import '../models/recurring_expense_model.dart';
import '../../../../core/services/sync_queue.dart';

class RecurringExpenseRepositoryImpl implements RecurringExpenseRepository {
  const RecurringExpenseRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
    this._syncQueue,
  );

  final RecurringExpenseLocalDataSource _localDataSource;
  final RecurringExpenseRemoteDataSource _remoteDataSource;
  final SyncQueue _syncQueue;

  @override
  Future<void> createRecurringExpense(RecurringExpense recurringExpense) async {
    final model = RecurringExpenseModel.fromEntity(recurringExpense);
    await _localDataSource.createRecurringExpense(model);
    await _syncQueue.enqueueUpsert(
      table: 'recurring_expenses',
      entityId: model.id,
      payloadBuilder: model.toRemoteJson,
    );
    unawaited(_syncQueue.sync());
  }

  @override
  Future<List<RecurringExpense>> getRecurringExpenses() async {
    await _syncFromRemote();
    final models = await _localDataSource.getRecurringExpenses();
    return models.map((model) => model.toEntity()).toList(growable: false);
  }

  @override
  Future<List<RecurringExpense>> getRecurringExpensesByCategoryId(
    String categoryId,
  ) async {
    final recurringExpenses = await getRecurringExpenses();
    return recurringExpenses
        .where((recurringExpense) => recurringExpense.categoryId == categoryId)
        .toList(growable: false);
  }

  @override
  Future<void> updateRecurringExpense(RecurringExpense recurringExpense) async {
    final model = RecurringExpenseModel.fromEntity(recurringExpense);
    await _localDataSource.updateRecurringExpense(model);
    await _syncQueue.enqueueUpsert(
      table: 'recurring_expenses',
      entityId: model.id,
      payloadBuilder: model.toRemoteJson,
    );
    unawaited(_syncQueue.sync());
  }

  @override
  Future<void> deleteRecurringExpense(String id) async {
    await _localDataSource.deleteRecurringExpense(id);
    await _syncQueue.enqueueDelete(
      table: 'recurring_expenses',
      entityId: id,
    );
    unawaited(_syncQueue.sync());
  }

  Future<void> _syncFromRemote() async {
    try {
      await _syncQueue.sync();
      final remoteRecurringExpenses = await _remoteDataSource
          .getRecurringExpenses();
      for (final item in remoteRecurringExpenses) {
        await _localDataSource.createRecurringExpense(item);
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
