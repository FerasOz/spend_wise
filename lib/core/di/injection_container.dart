import 'package:get_it/get_it.dart';
import 'package:spend_wise/core/services/app_clock.dart';
import 'package:spend_wise/core/services/id_generator.dart';
import 'package:spend_wise/core/di/register_category_feature.dart';
import 'package:spend_wise/core/di/register_expense_feature.dart';
import 'package:spend_wise/core/di/register_budget_feature.dart';
import 'package:spend_wise/core/di/register_recurring_feature.dart';
import 'package:spend_wise/core/di/register_dashboard_feature.dart';
import 'package:spend_wise/core/di/register_insights_feature.dart';
import 'package:spend_wise/core/di/register_settings_feature.dart';
import 'package:spend_wise/core/di/register_export_feature.dart';
import 'package:spend_wise/core/di/register_local_storage.dart';

import '../../app/shell/cubit/shell_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> setupDependencies() async {
  // Initialize local storage (Hive boxes) in a separate module
  await registerLocalStorage(sl);

  if (!sl.isRegistered<AppClock>()) {
    sl.registerLazySingleton<AppClock>(() => const SystemAppClock());
  }

  if (!sl.isRegistered<ShellCubit>()) {
    sl.registerFactory<ShellCubit>(() => ShellCubit());
  }

  // Register lightweight infra services
  if (!sl.isRegistered<IdGenerator>()) {
    sl.registerLazySingleton<IdGenerator>(() => const TimestampIdGenerator());
  }

  // ============================================================================
  // EXPENSE FEATURE
  // ============================================================================
  await registerExpenseFeature(sl);

  // Category feature DI moved to a module for clarity
  await registerCategoryFeature(sl);

  // ============================================================================
  // BUDGET FEATURE
  // ============================================================================
  await registerBudgetFeature(sl);

  // ============================================================================
  // RECURRING FEATURE
  // ============================================================================
  await registerRecurringFeature(sl);

  // ============================================================================
  // DASHBOARD FEATURE
  // ============================================================================
  await registerDashboardFeature(sl);

  // ============================================================================
  // INSIGHTS FEATURE
  // ============================================================================
  await registerInsightsFeature(sl);

  // ============================================================================
  // SETTINGS FEATURE
  // ============================================================================
  await registerSettingsFeature(sl);

  // ============================================================================
  // EXPORT FEATURE
  // ============================================================================
  await registerExportFeature(sl);
}
