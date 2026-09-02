import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/budget_model.dart';

abstract class BudgetRemoteDataSource {
  Future<void> createBudget(BudgetModel budget);

  Future<List<BudgetModel>> getBudgets();

  Future<void> updateBudget(BudgetModel budget);

  Future<void> deleteBudget(String id);
}

class SupabaseBudgetRemoteDataSource implements BudgetRemoteDataSource {
  final SupabaseClient _client;

  const SupabaseBudgetRemoteDataSource(this._client);

  static const String tableName = 'budgets';

  @override
  Future<void> createBudget(BudgetModel budget) async {
    await _client.from(tableName).upsert(budget.toRemoteJson(_userId));
  }

  @override
  Future<List<BudgetModel>> getBudgets() async {
    final response = await _client.from(tableName).select();
    return (response as List)
        .map(
          (json) => BudgetModel.fromRemoteJson(Map<String, dynamic>.from(json)),
        )
        .toList(growable: false);
  }

  @override
  Future<void> updateBudget(BudgetModel budget) async {
    await _client.from(tableName).upsert(budget.toRemoteJson(_userId));
  }

  @override
  Future<void> deleteBudget(String id) async {
    await _client.from(tableName).delete().eq('id', id);
  }

  String get _userId =>
      _client.auth.currentUser?.id ??
      (throw StateError('Cannot sync without an authenticated user.'));
}
