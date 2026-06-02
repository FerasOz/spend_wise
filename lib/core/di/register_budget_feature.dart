import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
import '../../core/services/app_clock.dart';
import '../../features/expenses/domain/repositories/expense_repository.dart';

Future<void> registerBudgetFeature(GetIt sl) async {
  // Budget Local Data Source
  if (!sl.isRegistered<BudgetLocalDataSource>()) {
    sl.registerLazySingleton<BudgetLocalDataSource>(
      () => HiveBudgetLocalDataSource(
        sl<Box<Map>>(instanceName: HiveBudgetLocalDataSource.boxName),
      ),
    );
  }

  // Budget Repository
  if (!sl.isRegistered<BudgetRepository>()) {
    sl.registerLazySingleton<BudgetRepository>(
      () => BudgetRepositoryImpl(sl<BudgetLocalDataSource>()),
    );
  }

  // Budget Use Cases
  if (!sl.isRegistered<CreateBudget>()) {
    sl.registerLazySingleton<CreateBudget>(
      () => CreateBudget(sl<BudgetRepository>()),
    );
  }

  if (!sl.isRegistered<GetBudgets>()) {
    sl.registerLazySingleton<GetBudgets>(
      () => GetBudgets(
        sl<BudgetRepository>(),
        sl<ExpenseRepository>(),
        sl<AppClock>(),
      ),
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

  // Budget Cubit
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
}
