import 'package:flutter_test/flutter_test.dart';
import 'package:spend_wise/features/expenses/data/datasources/expense_local_data_source.dart';
import 'package:spend_wise/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:spend_wise/features/expenses/data/models/expense_model.dart';
import 'package:spend_wise/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense.dart';

void main() {
  group('ExpenseRepositoryImpl', () {
    late SpyExpenseLocalDataSource localDataSource;
    late SpyExpenseRemoteDataSource remoteDataSource;
    late ExpenseRepositoryImpl repository;

    final tExpense = Expense(
      id: '1',
      title: 'Coffee',
      amount: 4.5,
      categoryId: 'cat_food',
      date: DateTime(2026, 6, 11),
      createdAt: DateTime(2026, 6, 11),
      updatedAt: DateTime(2026, 6, 11),
    );

    setUp(() {
      localDataSource = SpyExpenseLocalDataSource();
      remoteDataSource = SpyExpenseRemoteDataSource();
      repository = ExpenseRepositoryImpl(localDataSource, remoteDataSource);
    });

    test('addExpense should write to local and then remote', () async {
      await repository.addExpense(tExpense);

      expect(localDataSource.addExpenseCalled, true);
      expect(remoteDataSource.addExpenseCalled, true);
      expect(localDataSource.expenses.first.id, '1');
      expect(remoteDataSource.expenses.first.id, '1');
    });

    test('addExpense should not throw when remote throws (offline fallback)', () async {
      remoteDataSource.shouldThrow = true;

      // Should complete normally without throwing
      await expectLater(repository.addExpense(tExpense), completes);

      expect(localDataSource.addExpenseCalled, true);
      expect(remoteDataSource.addExpenseCalled, true);
      expect(localDataSource.expenses.first.id, '1');
      expect(remoteDataSource.expenses, isEmpty);
    });

    test('updateExpense should update both local and remote', () async {
      await repository.addExpense(tExpense);
      final updated = tExpense.copyWith(title: 'Latte');

      await repository.updateExpense(updated);

      expect(localDataSource.updateExpenseCalled, true);
      expect(remoteDataSource.updateExpenseCalled, true);
      expect(localDataSource.expenses.first.title, 'Latte');
      expect(remoteDataSource.expenses.first.title, 'Latte');
    });

    test('updateExpense should not throw when remote throws', () async {
      await repository.addExpense(tExpense);
      final updated = tExpense.copyWith(title: 'Latte');
      remoteDataSource.shouldThrow = true;

      await expectLater(repository.updateExpense(updated), completes);

      expect(localDataSource.updateExpenseCalled, true);
      expect(localDataSource.expenses.first.title, 'Latte');
      expect(remoteDataSource.expenses.first.title, 'Coffee'); // Remote not updated
    });

    test('deleteExpense should delete from both local and remote', () async {
      await repository.addExpense(tExpense);

      await repository.deleteExpense('1');

      expect(localDataSource.deleteExpenseCalled, true);
      expect(remoteDataSource.deleteExpenseCalled, true);
      expect(localDataSource.expenses, isEmpty);
      expect(remoteDataSource.expenses, isEmpty);
    });

    test('deleteExpense should not throw when remote throws', () async {
      await repository.addExpense(tExpense);
      remoteDataSource.shouldThrow = true;

      await expectLater(repository.deleteExpense('1'), completes);

      expect(localDataSource.deleteExpenseCalled, true);
      expect(localDataSource.expenses, isEmpty);
      expect(remoteDataSource.expenses.first.id, '1'); // Remote not deleted
    });

    test('getExpenses should pull from remote to local cache and return results', () async {
      remoteDataSource.expenses.add(ExpenseModel.fromEntity(tExpense));

      final result = await repository.getExpenses();

      expect(remoteDataSource.getExpensesCalled, true);
      expect(localDataSource.expenses.first.id, '1');
      expect(result.first.id, '1');
    });

    test('getExpenses should fallback to local when remote throws', () async {
      localDataSource.expenses.add(ExpenseModel.fromEntity(tExpense));
      remoteDataSource.shouldThrow = true;

      final result = await repository.getExpenses();

      expect(remoteDataSource.getExpensesCalled, true);
      expect(result.first.id, '1');
    });
  });
}

class SpyExpenseLocalDataSource implements ExpenseLocalDataSource {
  final List<ExpenseModel> expenses = [];
  bool addExpenseCalled = false;
  bool getExpensesCalled = false;
  bool updateExpenseCalled = false;
  bool deleteExpenseCalled = false;

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    addExpenseCalled = true;
    expenses.add(expense);
  }

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    getExpensesCalled = true;
    return expenses;
  }

  @override
  Future<List<ExpenseModel>> getExpensesByCategoryId(String categoryId) async {
    return expenses.where((e) => e.categoryId == categoryId).toList();
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    updateExpenseCalled = true;
    final idx = expenses.indexWhere((e) => e.id == expense.id);
    if (idx != -1) {
      expenses[idx] = expense;
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    deleteExpenseCalled = true;
    expenses.removeWhere((e) => e.id == id);
  }
}

class SpyExpenseRemoteDataSource implements ExpenseRemoteDataSource {
  final List<ExpenseModel> expenses = [];
  bool addExpenseCalled = false;
  bool getExpensesCalled = false;
  bool updateExpenseCalled = false;
  bool deleteExpenseCalled = false;
  bool shouldThrow = false;

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    addExpenseCalled = true;
    if (shouldThrow) throw Exception('Network error');
    expenses.add(expense);
  }

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    getExpensesCalled = true;
    if (shouldThrow) throw Exception('Network error');
    return expenses;
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    updateExpenseCalled = true;
    if (shouldThrow) throw Exception('Network error');
    final idx = expenses.indexWhere((e) => e.id == expense.id);
    if (idx != -1) {
      expenses[idx] = expense;
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    deleteExpenseCalled = true;
    if (shouldThrow) throw Exception('Network error');
    expenses.removeWhere((e) => e.id == id);
  }
}
