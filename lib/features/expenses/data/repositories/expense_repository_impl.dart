import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_data_source.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  const ExpenseRepositoryImpl(this._localDataSource);

  final ExpenseLocalDataSource _localDataSource;

  @override
  Future<void> addExpense(Expense expense) {
    final expenseModel = ExpenseModel.fromEntity(expense);
    return _localDataSource.addExpense(expenseModel);
  }

  @override
  Future<List<Expense>> getExpenses() async {
    final expenseModels = await _localDataSource.getExpenses();
    return expenseModels
        .map((expenseModel) => expenseModel.toEntity())
        .toList(growable: false);
  }

  @override
  Future<void> updateExpense(Expense expense) {
    final expenseModel = ExpenseModel.fromEntity(expense);
    return _localDataSource.updateExpense(expenseModel);
  }

  @override
  Future<void> deleteExpense(String id) {
    return _localDataSource.deleteExpense(id);
  }
}
