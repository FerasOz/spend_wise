import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/services/app_clock.dart';
import '../../core/services/id_generator.dart';
import '../../core/constants/default_category_ids.dart';
import '../../features/budgets/data/datasources/budget_local_data_source.dart';
import '../../features/budgets/domain/repositories/budget_repository.dart';
import '../../features/categories/data/datasources/category_local_data_source.dart';
import '../../features/categories/data/datasources/category_remote_data_source.dart';
import '../../features/categories/data/repositories/category_repository_impl.dart';
import '../../features/categories/domain/repositories/category_repository.dart';
import '../../features/categories/domain/usecases/add_category.dart';
import '../../features/categories/domain/usecases/can_delete_category.dart';
import '../../features/categories/domain/usecases/can_delete_category_referential_integrity.dart';
import '../../features/categories/domain/usecases/delete_category.dart';
import '../../features/categories/domain/usecases/get_categories.dart';
import '../../features/categories/domain/usecases/update_category.dart';
import '../../features/expenses/domain/repositories/expense_repository.dart';
import '../../features/expenses/data/datasources/expense_local_data_source.dart';
import '../../features/recurring/domain/repositories/recurring_expense_repository.dart';
import '../../features/recurring/data/datasources/recurring_expense_local_data_source.dart';
import '../../features/categories/presentation/cubit/category_cubit.dart';

Future<void> registerCategoryFeature(GetIt sl) async {
  // Hive Box for Categories
  if (!sl.isRegistered<Box<Map>>(
    instanceName: HiveCategoryLocalDataSource.boxName,
  )) {
    final categoriesBox = await Hive.openBox<Map>(
      HiveCategoryLocalDataSource.boxName,
    );

    await _migrateLegacyDefaultCategoryIds(
      categoriesBox,
      sl<Box<Map>>(instanceName: HiveExpenseLocalDataSource.boxName),
      sl<Box<Map>>(instanceName: HiveBudgetLocalDataSource.boxName),
      sl<Box<Map>>(instanceName: HiveRecurringExpenseLocalDataSource.boxName),
    );

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

  // Category Remote Data Source
  if (!sl.isRegistered<CategoryRemoteDataSource>()) {
    sl.registerLazySingleton<CategoryRemoteDataSource>(
      () => SupabaseCategoryRemoteDataSource(Supabase.instance.client),
    );
  }

  // Category Repository
  if (!sl.isRegistered<CategoryRepository>()) {
    sl.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(
        sl<CategoryLocalDataSource>(),
        sl<CategoryRemoteDataSource>(),
      ),
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

  if (!sl.isRegistered<CanDeleteCategoryReferentialIntegrity>()) {
    sl.registerLazySingleton<CanDeleteCategoryReferentialIntegrity>(
      () => CanDeleteCategoryReferentialIntegrity(
        sl<CategoryRepository>(),
        sl<ExpenseRepository>(),
        sl<BudgetRepository>(),
        sl<RecurringExpenseRepository>(),
      ),
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
        canDeleteCategoryReferentialIntegrity:
            sl<CanDeleteCategoryReferentialIntegrity>(),
        clock: sl<AppClock>(),
        idGenerator: sl<IdGenerator>(),
      ),
    );
  }
}

Future<void> _migrateLegacyDefaultCategoryIds(
  Box<Map> categoriesBox,
  Box<Map> expensesBox,
  Box<Map> budgetsBox,
  Box<Map> recurringExpensesBox,
) async {
  const replacements = {
    DefaultCategoryIds.legacyShopping: DefaultCategoryIds.shopping,
    DefaultCategoryIds.legacyFood: DefaultCategoryIds.food,
    DefaultCategoryIds.legacyTransport: DefaultCategoryIds.transport,
    DefaultCategoryIds.legacyEntertainment: DefaultCategoryIds.entertainment,
    DefaultCategoryIds.legacyUtilities: DefaultCategoryIds.utilities,
    DefaultCategoryIds.legacyHealth: DefaultCategoryIds.health,
  };

  for (final replacement in replacements.entries) {
    final category = categoriesBox.get(replacement.key);
    if (category == null) continue;

    final updatedCategory = Map<String, dynamic>.from(category)
      ..['id'] = replacement.value;
    await categoriesBox.delete(replacement.key);
    await categoriesBox.put(replacement.value, updatedCategory);

    await _replaceCategoryId(expensesBox, replacement.key, replacement.value);
    await _replaceCategoryId(budgetsBox, replacement.key, replacement.value);
    await _replaceCategoryId(
      recurringExpensesBox,
      replacement.key,
      replacement.value,
    );
  }
}

Future<void> _replaceCategoryId(
  Box<Map> box,
  String legacyId,
  String uuid,
) async {
  for (final key in box.keys) {
    final item = Map<String, dynamic>.from(box.get(key)!);
    if (item['categoryId'] != legacyId) continue;
    item['categoryId'] = uuid;
    await box.put(key, item);
  }
}
