import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/expenses/data/datasources/expense_local_data_source.dart';
import '../../features/budgets/data/datasources/budget_local_data_source.dart';
import '../../features/recurring/data/datasources/recurring_expense_local_data_source.dart';
import '../../features/settings/data/datasources/settings_local_data_source.dart';
import '../../features/export/data/datasources/export_history_local_data_source.dart';

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
}
