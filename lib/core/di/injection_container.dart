import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../app/shell/cubit/shell_cubit.dart';
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
import '../../features/expenses/domain/usecases/update_expense.dart';
import '../../features/expenses/presentation/cubit/expense_cubit.dart';

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
        getDashboardInsights: sl<GetDashboardInsights>(),
        getDashboardSummary: sl<GetDashboardSummary>(),
        getWeeklySpending: sl<GetWeeklySpending>(),
        getRecentExpenses: sl<GetRecentExpenses>(),
        getTopCategories: sl<GetTopCategories>(),
      ),
    );
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
