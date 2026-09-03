import 'dart:async';
import 'dart:developer' as developer;

import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_data_source.dart';
import '../datasources/expense_remote_data_source.dart';
import '../models/expense_model.dart';
import '../../../../core/services/sync_queue.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  const ExpenseRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
    this._syncQueue,
  );

  final ExpenseLocalDataSource _localDataSource;
  final ExpenseRemoteDataSource _remoteDataSource;
  final SyncQueue _syncQueue;

  @override
  Future<void> addExpense(Expense expense) async {
    final expenseModel = ExpenseModel.fromEntity(expense);
    await _localDataSource.addExpense(expenseModel);
    await _syncQueue.enqueueUpsert(
      table: 'expenses',
      entityId: expenseModel.id,
      payloadBuilder: expenseModel.toRemoteJson,
    );
    unawaited(_syncQueue.sync());
  }

  @override
  Future<List<Expense>> getExpenses() async {
    await _syncFromRemote();
    return getLocalExpenses();
  }

  @override
  Future<List<Expense>> getLocalExpenses() async {
    final expenseModels = await _localDataSource.getExpenses();
    return expenseModels
        .map((expenseModel) => expenseModel.toEntity())
        .toList(growable: false);
  }

  @override
  Future<List<Expense>> getExpensesByCategoryId(String categoryId) async {
    await _syncFromRemote();
    final expenseModels = await _localDataSource.getExpensesByCategoryId(
      categoryId,
    );
    return expenseModels
        .map((expenseModel) => expenseModel.toEntity())
        .toList(growable: false);
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    final expenseModel = ExpenseModel.fromEntity(expense);
    await _localDataSource.updateExpense(expenseModel);
    await _syncQueue.enqueueUpsert(
      table: 'expenses',
      entityId: expenseModel.id,
      payloadBuilder: expenseModel.toRemoteJson,
    );
    unawaited(_syncQueue.sync());
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _localDataSource.deleteExpense(id);
    await _syncQueue.enqueueDelete(table: 'expenses', entityId: id);
    unawaited(_syncQueue.sync());
  }

  Future<void> _syncWrite(Future<void> Function() write) async {
    try {
      await write();
    } catch (error, stackTrace) {
      developer.log(
        'Expense write was saved locally but could not be synced to Supabase.',
        name: 'SpendWise.Sync',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _syncFromRemote() async {
    try {
      await _syncQueue.sync();
      final remoteExpenses = await _remoteDataSource.getExpenses();
      for (final expense in remoteExpenses) {
        await _localDataSource.addExpense(expense);
      }

    } catch (error, stackTrace) {
      developer.log(
        'Could not fetch expenses from Supabase; using local data.',
        name: 'SpendWise.Sync',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
