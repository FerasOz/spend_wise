import '../models/budget_model.dart';
import 'package:hive/hive.dart';

abstract class BudgetLocalDataSource {
  Future<void> createBudget(BudgetModel budget);

  Future<List<BudgetModel>> getBudgets();

  Future<void> updateBudget(BudgetModel budget);

  Future<void> deleteBudget(String id);
}

class HiveBudgetLocalDataSource implements BudgetLocalDataSource {
  HiveBudgetLocalDataSource(this._box);

  static const String boxName = 'budgets_box';

  final Box<Map> _box;

  @override
  Future<void> createBudget(BudgetModel budget) async {
    await _box.put(budget.id, budget.toMap());
  }

  @override
  Future<List<BudgetModel>> getBudgets() async {
    return _box.values
        .map((value) => BudgetModel.fromMap(Map<String, dynamic>.from(value)))
        .toList(growable: false);
  }

  @override
  Future<void> updateBudget(BudgetModel budget) async {
    await _box.put(budget.id, budget.toMap());
  }

  @override
  Future<void> deleteBudget(String id) async {
    await _box.delete(id);
  }
}
