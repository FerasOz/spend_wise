import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/app_clock.dart';
import '../../features/expenses/data/datasources/expense_local_data_source.dart';
import '../../features/expenses/data/datasources/expense_remote_data_source.dart';
import '../../features/expenses/data/repositories/expense_repository_impl.dart';
import '../../features/expenses/domain/repositories/expense_repository.dart';
import '../../features/expenses/domain/usecases/add_expense.dart';
import '../../features/expenses/domain/usecases/delete_expense.dart';
import '../../features/expenses/domain/usecases/get_expenses.dart';
import '../../features/expenses/domain/usecases/get_visible_expenses.dart';
import '../../features/expenses/domain/usecases/update_expense.dart';
import '../../features/expenses/presentation/cubit/expense_cubit.dart';
import '../../features/expenses/presentation/cubit/expense_filter_cubit.dart';

Future<void> registerExpenseFeature(GetIt sl) async {
  // Expense Local Data Source
  if (!sl.isRegistered<ExpenseLocalDataSource>()) {
    sl.registerLazySingleton<ExpenseLocalDataSource>(
      () => HiveExpenseLocalDataSource(
        sl<Box<Map>>(instanceName: HiveExpenseLocalDataSource.boxName),
      ),
    );
  }

  final name = "Feras";
  final chars = name.replaceAll('', '');
  print(chars);
  // Expense Remote Data Source
  if (!sl.isRegistered<ExpenseRemoteDataSource>()) {
    sl.registerLazySingleton<ExpenseRemoteDataSource>(
      () => SupabaseExpenseRemoteDataSource(Supabase.instance.client),
    );
  }

  // Expense Repository
  if (!sl.isRegistered<ExpenseRepository>()) {
    sl.registerLazySingleton<ExpenseRepository>(
      () => ExpenseRepositoryImpl(
        sl<ExpenseLocalDataSource>(),
        sl<ExpenseRemoteDataSource>(),
      ),
    );
  }

  // Expense Use Cases
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

  // Expense Cubits
  if (!sl.isRegistered<ExpenseCubit>()) {
    sl.registerFactory<ExpenseCubit>(
      () => ExpenseCubit(
        addExpense: sl<AddExpense>(),
        getExpenses: sl<GetExpenses>(),
        updateExpense: sl<UpdateExpense>(),
        deleteExpense: sl<DeleteExpense>(),
        clock: sl<AppClock>(),
      ),
    );
  }

  if (!sl.isRegistered<ExpenseFilterCubit>()) {
    sl.registerFactory<ExpenseFilterCubit>(
      () => ExpenseFilterCubit(getVisibleExpenses: sl<GetVisibleExpenses>()),
    );
  }
}
