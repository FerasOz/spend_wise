import 'dart:async';

import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_data_source.dart';
import '../datasources/expense_remote_data_source.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  const ExpenseRepositoryImpl(this._localDataSource, this._remoteDataSource);

  final ExpenseLocalDataSource _localDataSource;
  final ExpenseRemoteDataSource _remoteDataSource;

  @override
  Future<void> addExpense(Expense expense) async {
    final expenseModel = ExpenseModel.fromEntity(expense);
    await _localDataSource.addExpense(expenseModel);
    unawaited(_syncWrite(() => _remoteDataSource.addExpense(expenseModel)));
  }

  @override
  Future<List<Expense>> getExpenses() async {
    unawaited(_syncFromRemote());
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
    unawaited(_syncFromRemote());
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
    unawaited(_syncWrite(() => _remoteDataSource.updateExpense(expenseModel)));
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _localDataSource.deleteExpense(id);
    unawaited(_syncWrite(() => _remoteDataSource.deleteExpense(id)));
  }

  Future<void> _syncWrite(Future<void> Function() write) async {
    try {
      await write();
    } catch (_) {
      // Offline fallback
    }
  }

  Future<void> _syncFromRemote() async {
    try {
      final remoteExpenses = await _remoteDataSource.getExpenses();
      for (final expense in remoteExpenses) {
        await _localDataSource.addExpense(expense);
      }
    } catch (_) {
      // Offline fallback
    }
  }
}
