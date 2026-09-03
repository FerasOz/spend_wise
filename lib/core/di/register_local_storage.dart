import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/expenses/data/datasources/expense_local_data_source.dart';
import '../../features/budgets/data/datasources/budget_local_data_source.dart';
import '../../features/recurring/data/datasources/recurring_expense_local_data_source.dart';
import '../../features/settings/data/datasources/settings_local_data_source.dart';
import '../../features/export/data/datasources/export_history_local_data_source.dart';
import '../services/user_data_scope.dart';
import '../services/sync_queue.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/categories/data/datasources/category_local_data_source.dart';

Future<void> registerLocalStorage(GetIt sl) async {
  // Initialize Hive and open boxes used by local features.
  await Hive.initFlutter();

  if (!sl.isRegistered<Box<Map>>(
    instanceName: HiveExpenseLocalDataSource.boxName,
  )) {
    final expensesBox = await Hive.openBox<Map>(
      HiveExpenseLocalDataSource.boxName,
    );

    sl.registerSingleton<Box<Map>>(
      expensesBox,
      instanceName: HiveExpenseLocalDataSource.boxName,
    );
  }

  if (!sl.isRegistered<Box<Map>>(
    instanceName: HiveBudgetLocalDataSource.boxName,
  )) {
    final budgetsBox = await Hive.openBox<Map>(
      HiveBudgetLocalDataSource.boxName,
    );
    sl.registerSingleton<Box<Map>>(
      budgetsBox,
      instanceName: HiveBudgetLocalDataSource.boxName,
    );
  }

  if (!sl.isRegistered<Box<Map>>(
    instanceName: HiveRecurringExpenseLocalDataSource.boxName,
  )) {
    final recurringBox = await Hive.openBox<Map>(
      HiveRecurringExpenseLocalDataSource.boxName,
    );
    sl.registerSingleton<Box<Map>>(
      recurringBox,
      instanceName: HiveRecurringExpenseLocalDataSource.boxName,
    );
  }

  if (!sl.isRegistered<Box<Map>>(
    instanceName: HiveSettingsLocalDataSource.boxName,
  )) {
    final settingsBox = await Hive.openBox<Map>(
      HiveSettingsLocalDataSource.boxName,
    );
    sl.registerSingleton<Box<Map>>(
      settingsBox,
      instanceName: HiveSettingsLocalDataSource.boxName,
    );
  }

  if (!sl.isRegistered<Box<Map>>(
    instanceName: HiveExportHistoryLocalDataSource.boxName,
  )) {
    final historyBox = await Hive.openBox<Map>(
      HiveExportHistoryLocalDataSource.boxName,
    );
    sl.registerSingleton<Box<Map>>(
      historyBox,
      instanceName: HiveExportHistoryLocalDataSource.boxName,
    );
  }

  if (!sl.isRegistered<Box<String>>(instanceName: UserDataScope.boxName)) {
    final scopeBox = await Hive.openBox<String>(UserDataScope.boxName);
    sl.registerSingleton<Box<String>>(
      scopeBox,
      instanceName: UserDataScope.boxName,
    );
  }

  if (!sl.isRegistered<UserDataScope>()) {
    final categoriesBox = await Hive.openBox<Map>(
      HiveCategoryLocalDataSource.boxName,
    );
    sl.registerLazySingleton<UserDataScope>(
      () => UserDataScope(
        expensesBox: sl<Box<Map>>(
          instanceName: HiveExpenseLocalDataSource.boxName,
        ),
        categoriesBox: categoriesBox,
        budgetsBox: sl<Box<Map>>(instanceName: HiveBudgetLocalDataSource.boxName),
        recurringExpensesBox: sl<Box<Map>>(
          instanceName: HiveRecurringExpenseLocalDataSource.boxName,
        ),
        settingsBox: sl<Box<Map>>(instanceName: HiveSettingsLocalDataSource.boxName),
        exportHistoryBox: sl<Box<Map>>(
          instanceName: HiveExportHistoryLocalDataSource.boxName,
        ),
        scopeBox: sl<Box<String>>(instanceName: UserDataScope.boxName),
      ),
    );
  }

  if (!sl.isRegistered<Box<Map>>(instanceName: SyncQueue.boxName)) {
    final syncQueueBox = await Hive.openBox<Map>(SyncQueue.boxName);
    sl.registerSingleton<Box<Map>>(
      syncQueueBox,
      instanceName: SyncQueue.boxName,
    );
  }

  if (!sl.isRegistered<SyncQueue>()) {
    sl.registerLazySingleton<SyncQueue>(
      () => SyncQueue(
        sl<Box<Map>>(instanceName: SyncQueue.boxName),
        Supabase.instance.client,
      ),
    );
  }
}
