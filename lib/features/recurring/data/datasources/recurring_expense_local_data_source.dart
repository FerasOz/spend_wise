import 'package:hive/hive.dart';

import '../models/recurring_expense_model.dart';

abstract class RecurringExpenseLocalDataSource {
  Future<void> createRecurringExpense(RecurringExpenseModel recurringExpense);

  Future<List<RecurringExpenseModel>> getRecurringExpenses();

  Future<void> updateRecurringExpense(RecurringExpenseModel recurringExpense);

  Future<void> deleteRecurringExpense(String id);
}

class HiveRecurringExpenseLocalDataSource
    implements RecurringExpenseLocalDataSource {
  HiveRecurringExpenseLocalDataSource(this._box);

  static const String boxName = 'recurring_expenses_box';

  final Box<Map> _box;

  @override
  Future<void> createRecurringExpense(RecurringExpenseModel recurringExpense) {
    return _box.put(recurringExpense.id, recurringExpense.toJson());
  }

  @override
  Future<List<RecurringExpenseModel>> getRecurringExpenses() async {
    return _box.values
        .map((value) {
          return RecurringExpenseModel.fromJson(
            Map<String, dynamic>.from(value),
          );
        })
        .toList(growable: false);
  }

  @override
  Future<void> updateRecurringExpense(RecurringExpenseModel recurringExpense) {
    return _box.put(recurringExpense.id, recurringExpense.toJson());
  }

  @override
  Future<void> deleteRecurringExpense(String id) {
    return _box.delete(id);
  }
}
