import 'package:hive/hive.dart';

import '../models/expense_model.dart';

abstract class ExpenseLocalDataSource {
  Future<void> addExpense(ExpenseModel expense);

  Future<List<ExpenseModel>> getExpenses();

  Future<void> updateExpense(ExpenseModel expense);

  Future<void> deleteExpense(String id);
}

class HiveExpenseLocalDataSource implements ExpenseLocalDataSource {
  HiveExpenseLocalDataSource(this._box);

  static const String boxName = 'expenses_box';

  final Box<Map> _box;

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    await _box.put(expense.id, expense.toJson());
  }

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    return _box.values
        .map(
          (expenseMap) =>
              ExpenseModel.fromJson(Map<String, dynamic>.from(expenseMap)),
        )
        .toList(growable: false);
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    await _box.put(expense.id, expense.toJson());
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _box.delete(id);
  }
}
