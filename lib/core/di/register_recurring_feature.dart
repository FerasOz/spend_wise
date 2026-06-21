import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/recurring/data/datasources/recurring_expense_local_data_source.dart';
import '../../features/recurring/data/datasources/recurring_expense_remote_data_source.dart';
import '../../features/recurring/data/repositories/recurring_expense_repository_impl.dart';
import '../../features/recurring/domain/repositories/recurring_expense_repository.dart';
import '../../features/recurring/domain/usecases/create_recurring_expense.dart';
import '../../features/recurring/domain/usecases/delete_recurring_expense.dart';
import '../../features/recurring/domain/usecases/generate_due_expenses.dart';
import '../../features/recurring/domain/usecases/get_recurring_expenses.dart';
import '../../features/recurring/domain/usecases/update_recurring_expense.dart';
import '../../features/recurring/presentation/cubit/recurring_expense_cubit.dart';
import '../../core/services/app_clock.dart';
import '../../features/expenses/domain/repositories/expense_repository.dart';

Future<void> registerRecurringFeature(GetIt sl) async {
  // Recurring Expense Local Data Source
  if (!sl.isRegistered<RecurringExpenseLocalDataSource>()) {
    sl.registerLazySingleton<RecurringExpenseLocalDataSource>(
      () => HiveRecurringExpenseLocalDataSource(
        sl<Box<Map>>(instanceName: HiveRecurringExpenseLocalDataSource.boxName),
      ),
    );
  }

  // Recurring Expense Remote Data Source
  if (!sl.isRegistered<RecurringExpenseRemoteDataSource>()) {
    sl.registerLazySingleton<RecurringExpenseRemoteDataSource>(
      () => SupabaseRecurringExpenseRemoteDataSource(Supabase.instance.client),
    );
  }

  // Recurring Expense Repository
  if (!sl.isRegistered<RecurringExpenseRepository>()) {
    sl.registerLazySingleton<RecurringExpenseRepository>(
      () => RecurringExpenseRepositoryImpl(
        sl<RecurringExpenseLocalDataSource>(),
        sl<RecurringExpenseRemoteDataSource>(),
      ),
    );
  }

  // Recurring Expense Use Cases
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
        sl<AppClock>(),
      ),
    );
  }

  // Recurring Expense Cubit
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
}
