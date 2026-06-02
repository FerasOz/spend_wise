import 'package:get_it/get_it.dart';

import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/domain/usecases/get_dashboard_source_data.dart';
import '../../features/dashboard/domain/usecases/get_dashboard_summary.dart';
import '../../features/dashboard/domain/usecases/get_recent_expenses.dart';
import '../../features/dashboard/domain/usecases/get_top_categories.dart';
import '../../features/dashboard/domain/usecases/get_weekly_spending.dart';
import '../../features/dashboard/presentation/cubit/dashboard_cubit.dart';
import '../../core/services/app_clock.dart';
import '../../features/categories/domain/repositories/category_repository.dart';
import '../../features/expenses/domain/repositories/expense_repository.dart';
import '../../features/insights/domain/usecases/generate_insights.dart';

Future<void> registerDashboardFeature(GetIt sl) async {
  // Dashboard Repository
  if (!sl.isRegistered<DashboardRepository>()) {
    sl.registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(
        expenseRepository: sl<ExpenseRepository>(),
        categoryRepository: sl<CategoryRepository>(),
      ),
    );
  }

  // Dashboard Use Cases
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
      () => GetDashboardSummary(sl<GetTopCategories>(), sl<AppClock>()),
    );
  }

  if (!sl.isRegistered<GetWeeklySpending>()) {
    sl.registerLazySingleton<GetWeeklySpending>(
      () => GetWeeklySpending(sl<AppClock>()),
    );
  }

  if (!sl.isRegistered<GetRecentExpenses>()) {
    sl.registerLazySingleton<GetRecentExpenses>(
      () => const GetRecentExpenses(),
    );
  }

  // Dashboard Cubit
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
}
