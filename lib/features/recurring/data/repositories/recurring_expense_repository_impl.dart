import '../../domain/entities/recurring_expense.dart';
import '../../domain/repositories/recurring_expense_repository.dart';
import '../datasources/recurring_expense_local_data_source.dart';
import '../datasources/recurring_expense_remote_data_source.dart';
import '../models/recurring_expense_model.dart';

class RecurringExpenseRepositoryImpl implements RecurringExpenseRepository {
  const RecurringExpenseRepositoryImpl(this._localDataSource, this._remoteDataSource);

  final RecurringExpenseLocalDataSource _localDataSource;
  final RecurringExpenseRemoteDataSource _remoteDataSource;

  @override
  Future<void> createRecurringExpense(RecurringExpense recurringExpense) async {
    final model = RecurringExpenseModel.fromEntity(recurringExpense);
    await _localDataSource.createRecurringExpense(model);
    try {
      await _remoteDataSource.createRecurringExpense(model);
    } catch (_) {
      // Offline fallback
    }
  }

  @override
  Future<List<RecurringExpense>> getRecurringExpenses() async {
    try {
      final remoteRecurringExpenses = await _remoteDataSource.getRecurringExpenses();
      for (final item in remoteRecurringExpenses) {
        await _localDataSource.createRecurringExpense(item);
      }
    } catch (_) {
      // Offline fallback
    }

    final models = await _localDataSource.getRecurringExpenses();
    return models.map((model) => model.toEntity()).toList(growable: false);
  }

  @override
  Future<List<RecurringExpense>> getRecurringExpensesByCategoryId(String categoryId) async {
    final recurringExpenses = await getRecurringExpenses();
    return recurringExpenses.where((recurringExpense) => recurringExpense.categoryId == categoryId).toList(growable: false);
  }

  @override
  Future<void> updateRecurringExpense(RecurringExpense recurringExpense) async {
    final model = RecurringExpenseModel.fromEntity(recurringExpense);
    await _localDataSource.updateRecurringExpense(model);
    try {
      await _remoteDataSource.updateRecurringExpense(model);
    } catch (_) {
      // Offline fallback
    }
  }

  @override
  Future<void> deleteRecurringExpense(String id) async {
    await _localDataSource.deleteRecurringExpense(id);
    try {
      await _remoteDataSource.deleteRecurringExpense(id);
    } catch (_) {
      // Offline fallback
    }
  }
}
