import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/recurring_expense_model.dart';

abstract class RecurringExpenseRemoteDataSource {
  Future<void> createRecurringExpense(RecurringExpenseModel recurringExpense);

  Future<List<RecurringExpenseModel>> getRecurringExpenses();

  Future<void> updateRecurringExpense(RecurringExpenseModel recurringExpense);

  Future<void> deleteRecurringExpense(String id);
}

class SupabaseRecurringExpenseRemoteDataSource
    implements RecurringExpenseRemoteDataSource {
  final SupabaseClient _client;

  const SupabaseRecurringExpenseRemoteDataSource(this._client);

  static const String tableName = 'recurring_expenses';

  @override
  Future<void> createRecurringExpense(
    RecurringExpenseModel recurringExpense,
  ) async {
    await _client
        .from(tableName)
        .upsert(recurringExpense.toRemoteJson(_userId));
  }

  @override
  Future<List<RecurringExpenseModel>> getRecurringExpenses() async {
    final response = await _client.from(tableName).select();
    return (response as List)
        .map(
          (json) => RecurringExpenseModel.fromRemoteJson(
            Map<String, dynamic>.from(json),
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> updateRecurringExpense(
    RecurringExpenseModel recurringExpense,
  ) async {
    await _client
        .from(tableName)
        .upsert(recurringExpense.toRemoteJson(_userId));
  }

  @override
  Future<void> deleteRecurringExpense(String id) async {
    await _client.from(tableName).delete().eq('id', id);
  }

  String get _userId =>
      _client.auth.currentUser?.id ??
      (throw StateError('Cannot sync without an authenticated user.'));
}
