import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/services/app_clock.dart';
import '../../core/services/id_generator.dart';
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
import '../../features/recurring/domain/repositories/recurring_expense_repository.dart';
import '../../features/categories/presentation/cubit/category_cubit.dart';

Future<void> registerCategoryFeature(GetIt sl) async {
  // Hive Box for Categories
  if (!sl.isRegistered<Box<Map>>(
    instanceName: HiveCategoryLocalDataSource.boxName,
  )) {
    final categoriesBox = await Hive.openBox<Map>(
      HiveCategoryLocalDataSource.boxName,
    );

    // Initialize with default categories if box is empty
    if (categoriesBox.isEmpty) {
      await _initializeDefaultCategories(categoriesBox, sl<AppClock>());
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

/// Initialize the categories box with default categories
Future<void> _initializeDefaultCategories(Box<Map> box, AppClock clock) async {
  final defaultCategories = [
    {
      'id': 'cat_shopping',
      'name': 'Shopping',
      'icon': 'shopping_cart',
      'color': 0xFFFF6B6B,
      'isDefault': true,
      'createdAt': clock.now().toIso8601String(),
    },
    {
      'id': 'cat_food',
      'name': 'Food & Dining',
      'icon': 'restaurant',
      'color': 0xFFFF922B,
      'isDefault': true,
      'createdAt': clock.now().toIso8601String(),
    },
    {
      'id': 'cat_transport',
      'name': 'Transport',
      'icon': 'directions_car',
      'color': 0xFF0C93E4,
      'isDefault': true,
      'createdAt': clock.now().toIso8601String(),
    },
    {
      'id': 'cat_entertainment',
      'name': 'Entertainment',
      'icon': 'movie',
      'color': 0xFF7950F2,
      'isDefault': true,
      'createdAt': clock.now().toIso8601String(),
    },
    {
      'id': 'cat_utilities',
      'name': 'Utilities',
      'icon': 'electricity',
      'color': 0xFF20C997,
      'isDefault': true,
      'createdAt': clock.now().toIso8601String(),
    },
    {
      'id': 'cat_health',
      'name': 'Health & Fitness',
      'icon': 'health_and_safety',
      'color': 0xFF69DB7C,
      'isDefault': true,
      'createdAt': clock.now().toIso8601String(),
    },
  ];

  for (final category in defaultCategories) {
    await box.put(category['id'], category);
  }
}
