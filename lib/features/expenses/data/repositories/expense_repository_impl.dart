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
    try {
      await _remoteDataSource.addExpense(expenseModel);
    } catch (_) {
      // Offline fallback: catch remote exceptions
    }
  }

  @override
  Future<List<Expense>> getExpenses() async {
    try {
      final remoteExpenses = await _remoteDataSource.getExpenses();
      for (final expense in remoteExpenses) {
        await _localDataSource.addExpense(expense);
      }
    } catch (_) {
      // Offline fallback: ignore errors, fetch from local datasource below
    }

    final expenseModels = await _localDataSource.getExpenses();
    return expenseModels
        .map((expenseModel) => expenseModel.toEntity())
        .toList(growable: false);
  }

  @override
  Future<List<Expense>> getExpensesByCategoryId(String categoryId) async {
    try {
      final remoteExpenses = await _remoteDataSource.getExpenses();
      for (final expense in remoteExpenses) {
        await _localDataSource.addExpense(expense);
      }
    } catch (_) {
      // Offline fallback
    }

    final expenseModels = await _localDataSource.getExpensesByCategoryId(categoryId);
    return expenseModels
        .map((expenseModel) => expenseModel.toEntity())
        .toList(growable: false);
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    final expenseModel = ExpenseModel.fromEntity(expense);
    await _localDataSource.updateExpense(expenseModel);
    try {
      await _remoteDataSource.updateExpense(expenseModel);
    } catch (_) {
      // Offline fallback: catch remote exceptions
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _localDataSource.deleteExpense(id);
    try {
      await _remoteDataSource.deleteExpense(id);
    } catch (_) {
      // Offline fallback: catch remote exceptions
    }
  }
}
