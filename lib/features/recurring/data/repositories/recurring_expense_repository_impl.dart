import '../../domain/entities/recurring_expense.dart';
import '../../domain/repositories/recurring_expense_repository.dart';
import '../datasources/recurring_expense_local_data_source.dart';
import '../models/recurring_expense_model.dart';

class RecurringExpenseRepositoryImpl implements RecurringExpenseRepository {
  const RecurringExpenseRepositoryImpl(this._localDataSource);

  final RecurringExpenseLocalDataSource _localDataSource;

  @override
  Future<void> createRecurringExpense(RecurringExpense recurringExpense) {
    return _localDataSource.createRecurringExpense(
      RecurringExpenseModel.fromEntity(recurringExpense),
    );
  }

  @override
  Future<List<RecurringExpense>> getRecurringExpenses() async {
    final models = await _localDataSource.getRecurringExpenses();
    return models.map((model) => model.toEntity()).toList(growable: false);
  }

  @override
  Future<void> updateRecurringExpense(RecurringExpense recurringExpense) {
    return _localDataSource.updateRecurringExpense(
      RecurringExpenseModel.fromEntity(recurringExpense),
    );
  }

  @override
  Future<void> deleteRecurringExpense(String id) {
    return _localDataSource.deleteRecurringExpense(id);
  }
}
