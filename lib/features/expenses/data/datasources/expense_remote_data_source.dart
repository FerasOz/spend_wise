import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/expense_model.dart';

abstract class ExpenseRemoteDataSource {
  Future<void> addExpense(ExpenseModel expense);

  Future<List<ExpenseModel>> getExpenses();

  Future<void> updateExpense(ExpenseModel expense);

  Future<void> deleteExpense(String id);
}

class SupabaseExpenseRemoteDataSource implements ExpenseRemoteDataSource {
  final SupabaseClient _client;

  const SupabaseExpenseRemoteDataSource(this._client);

  static const String tableName = 'expenses';

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    await _client.from(tableName).upsert(expense.toRemoteJson(_userId));
  }

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    final response = await _client.from(tableName).select();
    return (response as List)
        .map(
          (json) =>
              ExpenseModel.fromRemoteJson(Map<String, dynamic>.from(json)),
        )
        .toList(growable: false);
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    await _client.from(tableName).upsert(expense.toRemoteJson(_userId));
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _client.from(tableName).delete().eq('id', id);
  }

  String get _userId =>
      _client.auth.currentUser?.id ??
      (throw StateError('Cannot sync without an authenticated user.'));
}
