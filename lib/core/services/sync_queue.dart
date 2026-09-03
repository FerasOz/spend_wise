import 'dart:developer' as developer;

import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SyncQueue {
  SyncQueue(this._box, this._client);

  static const boxName = 'sync_queue_box';

  final Box<Map> _box;
  final SupabaseClient _client;
  Future<void>? _activeSync;

  Future<void> enqueueUpsert({
    required String table,
    required String entityId,
    required Map<String, dynamic> Function(String userId) payloadBuilder,
  }) async {
    final userId = _currentUserId;
    await _box.put(_key(userId, table, entityId), {
      'user_id': userId,
      'table': table,
      'entity_id': entityId,
      'action': 'upsert',
      'payload': payloadBuilder(userId),
    });
  }

  Future<void> enqueueDelete({
    required String table,
    required String entityId,
  }) async {
    final userId = _currentUserId;
    await _box.put(_key(userId, table, entityId), {
      'user_id': userId,
      'table': table,
      'entity_id': entityId,
      'action': 'delete',
    });
  }

  Future<void> sync() {
    final running = _activeSync;
    if (running != null) return running;
    final operation = _syncCurrentUser();
    _activeSync = operation;
    return operation.whenComplete(() => _activeSync = null);
  }

  Future<void> _syncCurrentUser() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    final entries = _box.keys
        .map((key) => MapEntry(key, Map<String, dynamic>.from(_box.get(key)!)))
        .where((entry) => entry.value['user_id'] == userId)
        .toList()
      ..sort((a, b) => _priority(a.value).compareTo(_priority(b.value)));

    for (final entry in entries) {
      final task = entry.value;
      try {
        final table = task['table'] as String;
        final id = task['entity_id'] as String;
        if (task['action'] == 'delete') {
          await _client.from(table).delete().eq('id', id);
        } else {
          await _client.from(table).upsert(
                Map<String, dynamic>.from(task['payload'] as Map),
              );
        }
        await _box.delete(entry.key);
      } catch (error, stackTrace) {
        developer.log(
          'Sync paused; the pending operation remains queued.',
          name: 'SpendWise.Sync',
          error: error,
          stackTrace: stackTrace,
        );
        return;
      }
    }
  }

  int _priority(Map<String, dynamic> task) => switch (task['table']) {
    'categories' => 0,
    'expenses' => 1,
    'budgets' => 2,
    'recurring_expenses' => 3,
    _ => 4,
  };

  String get _currentUserId => _client.auth.currentUser?.id ??
      (throw StateError('Cannot queue data without an authenticated user.'));

  String _key(String userId, String table, String entityId) =>
      '$userId:$table:$entityId';
}
