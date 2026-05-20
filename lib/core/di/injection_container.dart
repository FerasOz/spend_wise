import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spend_wise/features/settings/domain/usecases/get_settings.dart';
import 'package:spend_wise/features/settings/domain/usecases/reset_all_settings.dart';
import 'package:spend_wise/features/settings/domain/usecases/toggle_auto_backup.dart';
import 'package:spend_wise/features/settings/domain/usecases/toggle_notifications.dart';
import 'package:spend_wise/features/settings/domain/usecases/update_currency.dart';
import 'package:spend_wise/features/settings/domain/usecases/update_language.dart';
import 'package:spend_wise/features/settings/domain/usecases/update_theme_mode.dart';

import '../../app/shell/cubit/shell_cubit.dart';
import '../../features/budgets/data/datasources/budget_local_data_source.dart';
import '../../features/budgets/data/repositories/budget_repository_impl.dart';
import '../../features/budgets/domain/repositories/budget_repository.dart';
import '../../features/budgets/domain/usecases/calculate_budget_progress.dart';
import '../../features/budgets/domain/usecases/create_budget.dart';
import '../../features/budgets/domain/usecases/delete_budget.dart';
import '../../features/budgets/domain/usecases/get_budget_by_category.dart';
import '../../features/budgets/domain/usecases/get_budgets.dart';
import '../../features/budgets/domain/usecases/update_budget.dart';
import '../../features/budgets/presentation/cubit/budget_cubit.dart';
import '../../features/categories/data/datasources/category_local_data_source.dart';
import '../../features/categories/data/repositories/category_repository_impl.dart';
import '../../features/categories/domain/repositories/category_repository.dart';
import '../../features/categories/domain/usecases/add_category.dart';
import '../../features/categories/domain/usecases/can_delete_category.dart';
import '../../features/categories/domain/usecases/delete_category.dart';
import '../../features/categories/domain/usecases/get_categories.dart';
import '../../features/categories/domain/usecases/update_category.dart';
import '../../features/categories/presentation/cubit/category_cubit.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/domain/usecases/get_dashboard_insights.dart';
import '../../features/dashboard/domain/usecases/get_dashboard_source_data.dart';
import '../../features/dashboard/domain/usecases/get_dashboard_summary.dart';
import '../../features/dashboard/domain/usecases/get_recent_expenses.dart';
import '../../features/dashboard/domain/usecases/get_top_categories.dart';
import '../../features/dashboard/domain/usecases/get_weekly_spending.dart';
import '../../features/dashboard/presentation/cubit/dashboard_cubit.dart';
import '../../features/expenses/data/datasources/expense_local_data_source.dart';
import '../../features/expenses/data/repositories/expense_repository_impl.dart';
import '../../features/expenses/domain/repositories/expense_repository.dart';
import '../../features/expenses/domain/usecases/add_expense.dart';
import '../../features/expenses/domain/usecases/delete_expense.dart';
import '../../features/expenses/domain/usecases/get_expenses.dart';
import '../../features/expenses/domain/usecases/get_visible_expenses.dart';
import '../../features/expenses/domain/usecases/update_expense.dart';
import '../../features/expenses/presentation/cubit/expense_cubit.dart';
import '../../features/expenses/presentation/cubit/expense_filter_cubit.dart';
import '../../features/recurring/data/datasources/recurring_expense_local_data_source.dart';
import '../../features/recurring/data/repositories/recurring_expense_repository_impl.dart';
import '../../features/recurring/domain/repositories/recurring_expense_repository.dart';
import '../../features/recurring/domain/usecases/create_recurring_expense.dart';
import '../../features/recurring/domain/usecases/delete_recurring_expense.dart';
import '../../features/recurring/domain/usecases/generate_due_expenses.dart';
import '../../features/recurring/domain/usecases/get_recurring_expenses.dart';
import '../../features/recurring/domain/usecases/update_recurring_expense.dart';
import '../../features/insights/domain/repositories/insight_repository.dart';
import '../../features/insights/data/repositories/insight_repository_impl.dart';
import '../../features/insights/domain/usecases/generate_insights.dart';
import '../../features/insights/presentation/cubit/insight_cubit.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/data/datasources/settings_local_data_source.dart';
import '../../features/settings/domain/usecases/watch_settings.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../features/export/domain/services/export_service.dart';
import '../../features/export/data/services/export_service_impl.dart';
import '../../features/export/presentation/cubit/export_cubit.dart';
import '../../features/recurring/presentation/cubit/recurring_expense_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> setupDependencies() async {
  await Hive.initFlutter();

  if (!sl.isRegistered<ShellCubit>()) {
    sl.registerFactory<ShellCubit>(() => ShellCubit());
  }

  // ============================================================================
  // CATEGORY FEATURE
  // ============================================================================

  // Hive Box for Categories
  if (!sl.isRegistered<Box<Map>>(
    instanceName: HiveCategoryLocalDataSource.boxName,
  )) {
    final categoriesBox = await Hive.openBox<Map>(
      HiveCategoryLocalDataSource.boxName,
    );

    // Initialize with default categories if box is empty
    if (categoriesBox.isEmpty) {
      await _initializeDefaultCategories(categoriesBox);
    }

    sl.registerSingleton<Box<Map>>(
      categoriesBox,
      instanceName: HiveCategoryLocalDataSource.boxName,
    );
  }

  // Category Local Data Source
  if (!sl.isRegistered<CategoryLocalDataSource>()) {
    sl.registerLazySingleton<CategoryLocalDataSource>(
      () => HiveCategoryLocalDataSource(
        sl<Box<Map>>(instanceName: HiveCategoryLocalDataSource.boxName),
      ),
    );
  }

  // Category Repository
  if (!sl.isRegistered<CategoryRepository>()) {
    sl.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(sl<CategoryLocalDataSource>()),
    );
  }

  // Category Use Cases
  if (!sl.isRegistered<AddCategory>()) {
    sl.registerLazySingleton<AddCategory>(
      () => AddCategory(sl<CategoryRepository>()),
    );
  }

  if (!sl.isRegistered<GetCategories>()) {
    sl.registerLazySingleton<GetCategories>(
      () => GetCategories(sl<CategoryRepository>()),
    );
  }

  if (!sl.isRegistered<UpdateCategory>()) {
    sl.registerLazySingleton<UpdateCategory>(
      () => UpdateCategory(sl<CategoryRepository>()),
    );
  }

  if (!sl.isRegistered<DeleteCategory>()) {
    sl.registerLazySingleton<DeleteCategory>(
      () => DeleteCategory(sl<CategoryRepository>()),
    );
  }

  if (!sl.isRegistered<CanDeleteCategory>()) {
    sl.registerLazySingleton<CanDeleteCategory>(
      () => CanDeleteCategory(sl<CategoryRepository>()),
    );
  }

  // Category Cubit
  if (!sl.isRegistered<CategoryCubit>()) {
    sl.registerFactory<CategoryCubit>(
      () => CategoryCubit(
        addCategory: sl<AddCategory>(),
        getCategories: sl<GetCategories>(),
        updateCategory: sl<UpdateCategory>(),
        deleteCategory: sl<DeleteCategory>(),
        canDeleteCategory: sl<CanDeleteCategory>(),
      ),
    );
  }

  // ============================================================================
  // EXPENSE FEATURE
  // ============================================================================

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

  if (!sl.isRegistered<ExpenseLocalDataSource>()) {
    sl.registerLazySingleton<ExpenseLocalDataSource>(
      () => HiveExpenseLocalDataSource(
        sl<Box<Map>>(instanceName: HiveExpenseLocalDataSource.boxName),
      ),
    );
  }

  if (!sl.isRegistered<ExpenseRepository>()) {
    sl.registerLazySingleton<ExpenseRepository>(
      () => ExpenseRepositoryImpl(sl<ExpenseLocalDataSource>()),
    );
  }

  if (!sl.isRegistered<AddExpense>()) {
    sl.registerLazySingleton<AddExpense>(
      () => AddExpense(sl<ExpenseRepository>()),
    );
  }

  if (!sl.isRegistered<GetExpenses>()) {
    sl.registerLazySingleton<GetExpenses>(
      () => GetExpenses(sl<ExpenseRepository>()),
    );
  }

  if (!sl.isRegistered<UpdateExpense>()) {
    sl.registerLazySingleton<UpdateExpense>(
      () => UpdateExpense(sl<ExpenseRepository>()),
    );
  }

  if (!sl.isRegistered<DeleteExpense>()) {
    sl.registerLazySingleton<DeleteExpense>(
      () => DeleteExpense(sl<ExpenseRepository>()),
    );
  }

  if (!sl.isRegistered<GetVisibleExpenses>()) {
    sl.registerLazySingleton<GetVisibleExpenses>(
      () => const GetVisibleExpenses(),
    );
  }

  if (!sl.isRegistered<ExpenseCubit>()) {
    sl.registerFactory<ExpenseCubit>(
      () => ExpenseCubit(
        addExpense: sl<AddExpense>(),
        getExpenses: sl<GetExpenses>(),
        updateExpense: sl<UpdateExpense>(),
        deleteExpense: sl<DeleteExpense>(),
      ),
    );
  }

  if (!sl.isRegistered<ExpenseFilterCubit>()) {
    sl.registerFactory<ExpenseFilterCubit>(
      () => ExpenseFilterCubit(getVisibleExpenses: sl<GetVisibleExpenses>()),
    );
  }

  // ============================================================================
  // BUDGET FEATURE
  // ============================================================================

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

  if (!sl.isRegistered<BudgetLocalDataSource>()) {
    sl.registerLazySingleton<BudgetLocalDataSource>(
      () => HiveBudgetLocalDataSource(
        sl<Box<Map>>(instanceName: HiveBudgetLocalDataSource.boxName),
      ),
    );
  }

  if (!sl.isRegistered<BudgetRepository>()) {
    sl.registerLazySingleton<BudgetRepository>(
      () => BudgetRepositoryImpl(sl<BudgetLocalDataSource>()),
    );
  }

  if (!sl.isRegistered<CreateBudget>()) {
    sl.registerLazySingleton<CreateBudget>(
      () => CreateBudget(sl<BudgetRepository>()),
    );
  }

  if (!sl.isRegistered<GetBudgets>()) {
    sl.registerLazySingleton<GetBudgets>(
      () => GetBudgets(sl<BudgetRepository>(), sl<ExpenseRepository>()),
    );
  }

  if (!sl.isRegistered<UpdateBudget>()) {
    sl.registerLazySingleton<UpdateBudget>(
      () => UpdateBudget(sl<BudgetRepository>()),
    );
  }

  if (!sl.isRegistered<DeleteBudget>()) {
    sl.registerLazySingleton<DeleteBudget>(
      () => DeleteBudget(sl<BudgetRepository>()),
    );
  }

  if (!sl.isRegistered<GetBudgetByCategory>()) {
    sl.registerLazySingleton<GetBudgetByCategory>(
      () => GetBudgetByCategory(sl<GetBudgets>()),
    );
  }

  if (!sl.isRegistered<CalculateBudgetProgress>()) {
    sl.registerLazySingleton<CalculateBudgetProgress>(
      () => const CalculateBudgetProgress(),
    );
  }

  if (!sl.isRegistered<BudgetCubit>()) {
    sl.registerFactory<BudgetCubit>(
      () => BudgetCubit(
        createBudget: sl<CreateBudget>(),
        getBudgets: sl<GetBudgets>(),
        updateBudget: sl<UpdateBudget>(),
        deleteBudget: sl<DeleteBudget>(),
        calculateBudgetProgress: sl<CalculateBudgetProgress>(),
      )..loadBudgets(),
    );
  }

  // ============================================================================
  // RECURRING FEATURE
  // ============================================================================

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

  if (!sl.isRegistered<RecurringExpenseLocalDataSource>()) {
    sl.registerLazySingleton<RecurringExpenseLocalDataSource>(
      () => HiveRecurringExpenseLocalDataSource(
        sl<Box<Map>>(instanceName: HiveRecurringExpenseLocalDataSource.boxName),
      ),
    );
  }

  if (!sl.isRegistered<RecurringExpenseRepository>()) {
    sl.registerLazySingleton<RecurringExpenseRepository>(
      () =>
          RecurringExpenseRepositoryImpl(sl<RecurringExpenseLocalDataSource>()),
    );
  }

  if (!sl.isRegistered<CreateRecurringExpense>()) {
    sl.registerLazySingleton<CreateRecurringExpense>(
      () => CreateRecurringExpense(sl<RecurringExpenseRepository>()),
    );
  }

  if (!sl.isRegistered<GetRecurringExpenses>()) {
    sl.registerLazySingleton<GetRecurringExpenses>(
      () => GetRecurringExpenses(sl<RecurringExpenseRepository>()),
    );
  }

  if (!sl.isRegistered<UpdateRecurringExpense>()) {
    sl.registerLazySingleton<UpdateRecurringExpense>(
      () => UpdateRecurringExpense(sl<RecurringExpenseRepository>()),
    );
  }

  if (!sl.isRegistered<DeleteRecurringExpense>()) {
    sl.registerLazySingleton<DeleteRecurringExpense>(
      () => DeleteRecurringExpense(sl<RecurringExpenseRepository>()),
    );
  }

  if (!sl.isRegistered<GenerateDueExpenses>()) {
    sl.registerLazySingleton<GenerateDueExpenses>(
      () => GenerateDueExpenses(
        sl<RecurringExpenseRepository>(),
        sl<ExpenseRepository>(),
      ),
    );
  }

  if (!sl.isRegistered<RecurringExpenseCubit>()) {
    sl.registerFactory<RecurringExpenseCubit>(
      () => RecurringExpenseCubit(
        createRecurringExpense: sl<CreateRecurringExpense>(),
        getRecurringExpenses: sl<GetRecurringExpenses>(),
        updateRecurringExpense: sl<UpdateRecurringExpense>(),
        deleteRecurringExpense: sl<DeleteRecurringExpense>(),
        generateDueExpenses: sl<GenerateDueExpenses>(),
      )..initialize(),
    );
  }

  // ============================================================================
  // DASHBOARD FEATURE
  // ============================================================================

  if (!sl.isRegistered<DashboardRepository>()) {
    sl.registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(
        expenseRepository: sl<ExpenseRepository>(),
        categoryRepository: sl<CategoryRepository>(),
      ),
    );
  }

  if (!sl.isRegistered<GetDashboardSourceData>()) {
    sl.registerLazySingleton<GetDashboardSourceData>(
      () => GetDashboardSourceData(sl<DashboardRepository>()),
    );
  }

  if (!sl.isRegistered<GetTopCategories>()) {
    sl.registerLazySingleton<GetTopCategories>(() => const GetTopCategories());
  }

  if (!sl.isRegistered<GetDashboardSummary>()) {
    sl.registerLazySingleton<GetDashboardSummary>(
      () => GetDashboardSummary(sl<GetTopCategories>()),
    );
  }

  if (!sl.isRegistered<GetDashboardInsights>()) {
    sl.registerLazySingleton<GetDashboardInsights>(
      () => GetDashboardInsights(sl<GetTopCategories>()),
    );
  }

  if (!sl.isRegistered<GetWeeklySpending>()) {
    sl.registerLazySingleton<GetWeeklySpending>(
      () => const GetWeeklySpending(),
    );
  }

  if (!sl.isRegistered<GetRecentExpenses>()) {
    sl.registerLazySingleton<GetRecentExpenses>(
      () => const GetRecentExpenses(),
    );
  }

  if (!sl.isRegistered<DashboardCubit>()) {
    sl.registerFactory<DashboardCubit>(
      () => DashboardCubit(
        getDashboardSourceData: sl<GetDashboardSourceData>(),
        getDashboardSummary: sl<GetDashboardSummary>(),
        getWeeklySpending: sl<GetWeeklySpending>(),
        getRecentExpenses: sl<GetRecentExpenses>(),
        getTopCategories: sl<GetTopCategories>(),
        generateInsights: sl<GenerateInsights>(),
      ),
    );
  }

  // ============================================================================
  // INSIGHTS FEATURE
  // ============================================================================

  if (!sl.isRegistered<InsightRepository>()) {
    sl.registerLazySingleton<InsightRepository>(() => InsightRepositoryImpl());
  }

  if (!sl.isRegistered<GenerateInsights>()) {
    sl.registerLazySingleton<GenerateInsights>(
      () => GenerateInsights(sl<InsightRepository>()),
    );
  }

  if (!sl.isRegistered<InsightCubit>()) {
    sl.registerFactory<InsightCubit>(
      () => InsightCubit(sl<GenerateInsights>()),
    );
  }

  // ============================================================================
  // SETTINGS FEATURE
  // ============================================================================

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

  if (!sl.isRegistered<SettingsLocalDataSource>()) {
    sl.registerLazySingleton<SettingsLocalDataSource>(
      () => HiveSettingsLocalDataSource(
        sl<Box<Map>>(instanceName: HiveSettingsLocalDataSource.boxName),
      ),
    );
  }

  if (!sl.isRegistered<SettingsRepository>()) {
    sl.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(sl<SettingsLocalDataSource>()),
    );
  }

  if (!sl.isRegistered<GetSettings>()) {
    sl.registerLazySingleton<GetSettings>(
      () => GetSettings(sl<SettingsRepository>()),
    );
  }

  if (!sl.isRegistered<UpdateThemeMode>()) {
    sl.registerLazySingleton<UpdateThemeMode>(
      () => UpdateThemeMode(sl<SettingsRepository>()),
    );
  }

  if (!sl.isRegistered<UpdateCurrency>()) {
    sl.registerLazySingleton<UpdateCurrency>(
      () => UpdateCurrency(sl<SettingsRepository>()),
    );
  }

  if (!sl.isRegistered<UpdateLanguage>()) {
    sl.registerLazySingleton<UpdateLanguage>(
      () => UpdateLanguage(sl<SettingsRepository>()),
    );
  }

  if (!sl.isRegistered<ToggleNotifications>()) {
    sl.registerLazySingleton<ToggleNotifications>(
      () => ToggleNotifications(sl<SettingsRepository>()),
    );
  }

  if (!sl.isRegistered<ToggleAutoBackup>()) {
    sl.registerLazySingleton<ToggleAutoBackup>(
      () => ToggleAutoBackup(sl<SettingsRepository>()),
    );
  }

  if (!sl.isRegistered<ResetAllSettings>()) {
    sl.registerLazySingleton<ResetAllSettings>(
      () => ResetAllSettings(sl<SettingsRepository>()),
    );
  }

  if (!sl.isRegistered<WatchSettings>()) {
    sl.registerLazySingleton<WatchSettings>(
      () => WatchSettings(sl<SettingsRepository>()),
    );
  }

  if (!sl.isRegistered<SettingsCubit>()) {
    sl.registerFactory<SettingsCubit>(
      () => SettingsCubit(
        getSettings: sl<GetSettings>(),
        updateThemeMode: sl<UpdateThemeMode>(),
        updateCurrency: sl<UpdateCurrency>(),
        updateLanguage: sl<UpdateLanguage>(),
        toggleNotifications: sl<ToggleNotifications>(),
        toggleAutoBackup: sl<ToggleAutoBackup>(),
        resetAllSettings: sl<ResetAllSettings>(),
        watchSettings: sl<WatchSettings>(),
      ),
    );
  }

  // ============================================================================
  // EXPORT FEATURE
  // ============================================================================

  if (!sl.isRegistered<ExportService>()) {
    sl.registerLazySingleton<ExportService>(() => ExportServiceImpl());
  }

  if (!sl.isRegistered<ExportCubit>()) {
    sl.registerFactory<ExportCubit>(() => ExportCubit(sl<ExportService>()));
  }
}

/// Initialize the categories box with default categories
///
/// Default categories help users get started without having to create them manually
Future<void> _initializeDefaultCategories(Box<Map> box) async {
  final defaultCategories = [
    {
      'id': 'cat_shopping',
      'name': 'Shopping',
      'icon': 'shopping_cart',
      'color': 0xFFFF6B6B, // Red
      'isDefault': true,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'id': 'cat_food',
      'name': 'Food & Dining',
      'icon': 'restaurant',
      'color': 0xFFFF922B, // Orange
      'isDefault': true,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'id': 'cat_transport',
      'name': 'Transport',
      'icon': 'directions_car',
      'color': 0xFF0C93E4, // Blue
      'isDefault': true,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'id': 'cat_entertainment',
      'name': 'Entertainment',
      'icon': 'movie',
      'color': 0xFF7950F2, // Purple
      'isDefault': true,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'id': 'cat_utilities',
      'name': 'Utilities',
      'icon': 'electricity',
      'color': 0xFF20C997, // Teal
      'isDefault': true,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'id': 'cat_health',
      'name': 'Health & Fitness',
      'icon': 'health_and_safety',
      'color': 0xFF69DB7C, // Green
      'isDefault': true,
      'createdAt': DateTime.now().toIso8601String(),
    },
  ];

  for (final category in defaultCategories) {
    await box.put(category['id'], category);
  }
}
