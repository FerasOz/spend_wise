import 'dart:async';

import 'package:spend_wise/features/categories/data/datasources/category_local_data_source.dart';
import 'package:spend_wise/features/categories/data/datasources/category_remote_data_source.dart';
import 'package:spend_wise/features/categories/data/models/category_model.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/categories/domain/repositories/category_repository.dart';
import 'package:spend_wise/core/services/id_generator.dart';
import 'package:spend_wise/core/constants/default_category_ids.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this._localDataSource, this._remoteDataSource);

  static const _sharedDefaultIds = {
    DefaultCategoryIds.shopping,
    DefaultCategoryIds.food,
    DefaultCategoryIds.transport,
    DefaultCategoryIds.entertainment,
    DefaultCategoryIds.utilities,
    DefaultCategoryIds.health,
  };

  final CategoryLocalDataSource _localDataSource;
  final CategoryRemoteDataSource _remoteDataSource;
  Future<void>? _activeSync;

  @override
  Future<void> addCategory(Category category) async {
    final categoryModel = CategoryModel.fromEntity(category);
    await _localDataSource.addCategory(categoryModel);
    unawaited(_syncWrite(() => _remoteDataSource.addCategory(categoryModel)));
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _localDataSource.deleteCategory(id);
    unawaited(_syncWrite(() => _remoteDataSource.deleteCategory(id)));
  }

  @override
  Future<List<Category>> getCategories() async {
    await _syncFromRemote();
    final categoryModels = await _localDataSource.getCategories();
    return categoryModels
        .map((categoryModel) => categoryModel.toEntity())
        .toList(growable: false);
  }

  @override
  Future<void> updateCategory(Category category) async {
    final categoryModel = CategoryModel.fromEntity(category);
    await _localDataSource.updateCategory(categoryModel);
    unawaited(_syncWrite(() => _remoteDataSource.updateCategory(categoryModel)));
  }

  Future<void> _syncFromRemote() {
    final activeSync = _activeSync;
    if (activeSync != null) return activeSync;

    final sync = _performSync();
    _activeSync = sync;
    return sync.whenComplete(() => _activeSync = null);
  }

  Future<void> _performSync() async {
    try {
      final remoteCategories = await _remoteDataSource.getCategories();
      final remoteCategoryIds = remoteCategories
          .map((category) => category.id)
          .toSet();
      final localBeforeRemoteSync = await _localDataSource.getCategories();
      for (final category in localBeforeRemoteSync) {
        if (category.isDefault &&
            _sharedDefaultIds.contains(category.id) &&
            !remoteCategoryIds.contains(category.id)) {
          await _localDataSource.deleteCategory(category.id);
        }
      }
      for (final category in remoteCategories) {
        await _localDataSource.addCategory(category);
      }

      if (remoteCategories.isEmpty) {
        // Older app versions used the same default UUIDs for every account.
        // They cannot be uploaded for a second account because `id` is the
        // primary key. Remove only those legacy defaults, keeping custom
        // offline categories intact.
        await _createDefaultCategories();

        for (final category in await _localDataSource.getCategories()) {
          if (!category.isDefault) {
            await _remoteDataSource.addCategory(category);
          }
        }
        return;
      }

      // Default categories are created locally on first launch. Upload any
      // local category that is not on the user's Supabase account yet.
      final localCategories = await _localDataSource.getCategories();
      for (final category in localCategories) {
        if (!remoteCategoryIds.contains(category.id)) {
          await _remoteDataSource.addCategory(category);
        }
      }
    } catch (_) {
      // Offline fallback
    }
  }

  Future<void> _createDefaultCategories() async {
    const generator = TimestampIdGenerator();
    final now = DateTime.now();
    final defaults = [
      ('Shopping', 'shopping_cart', 0xFFFF6B6B),
      ('Food & Dining', 'restaurant', 0xFFFF922B),
      ('Transport', 'directions_car', 0xFF0C93E4),
      ('Entertainment', 'movie', 0xFF7950F2),
      ('Utilities', 'electricity', 0xFF20C997),
      ('Health & Fitness', 'health_and_safety', 0xFF69DB7C),
    ];

    for (final item in defaults) {
      final category = CategoryModel(
        id: generator.generate(),
        name: item.$1,
        icon: item.$2,
        color: item.$3,
        isDefault: true,
        createdAt: now,
      );
      await _localDataSource.addCategory(category);
      await _remoteDataSource.addCategory(category);
    }
  }

  Future<void> _syncWrite(Future<void> Function() write) async {
    try {
      await write();
    } catch (_) {
      // Offline fallback
    }
  }
}
