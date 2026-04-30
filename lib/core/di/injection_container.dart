import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
}
