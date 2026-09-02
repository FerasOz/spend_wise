import 'package:hive_flutter/hive_flutter.dart';

/// Ensures that Hive data from one account is never shown to another account
/// on the same device.
class UserDataScope {
  UserDataScope({
    required Box<Map> expensesBox,
    required Box<Map> categoriesBox,
    required Box<Map> budgetsBox,
    required Box<Map> recurringExpensesBox,
    required Box<Map> settingsBox,
    required Box<Map> exportHistoryBox,
    required Box<String> scopeBox,
  }) : _dataBoxes = [
         expensesBox,
         categoriesBox,
         budgetsBox,
         recurringExpensesBox,
         settingsBox,
         exportHistoryBox,
       ],
       _scopeBox = scopeBox;

  static const boxName = 'user_data_scope_box';
  static const _activeUserKey = 'active_user_id';

  final List<Box<Map>> _dataBoxes;
  final Box<String> _scopeBox;

  Future<void> prepareForUser(String userId) async {
    if (_scopeBox.get(_activeUserKey) == userId) return;

    for (final box in _dataBoxes) {
      await box.clear();
    }
    await _scopeBox.put(_activeUserKey, userId);
  }
}
