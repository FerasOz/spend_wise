import 'dart:async';

import 'package:spend_wise/features/categories/data/datasources/category_local_data_source.dart';
import 'package:spend_wise/features/categories/data/datasources/category_remote_data_source.dart';
import 'package:spend_wise/features/categories/data/models/category_model.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/categories/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl(this._localDataSource, this._remoteDataSource);

  final CategoryLocalDataSource _localDataSource;
  final CategoryRemoteDataSource _remoteDataSource;

  @override
  Future<void> addCategory(Category category) async {
    final categoryModel = CategoryModel.fromEntity(category);
    await _localDataSource.addCategory(categoryModel);
    try {
      await _remoteDataSource.addCategory(categoryModel);
    } catch (_) {
      // Offline fallback
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _localDataSource.deleteCategory(id);
    try {
      await _remoteDataSource.deleteCategory(id);
    } catch (_) {
      // Offline fallback
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    unawaited(_syncFromRemote());
    final categoryModels = await _localDataSource.getCategories();
    return categoryModels
        .map((categoryModel) => categoryModel.toEntity())
        .toList(growable: false);
  }

  @override
  Future<void> updateCategory(Category category) async {
    final categoryModel = CategoryModel.fromEntity(category);
    await _localDataSource.updateCategory(categoryModel);
    try {
      await _remoteDataSource.updateCategory(categoryModel);
    } catch (_) {
      // Offline fallback
    }
  }

  Future<void> _syncFromRemote() async {
    try {
      final remoteCategories = await _remoteDataSource.getCategories();
      for (final category in remoteCategories) {
        await _localDataSource.addCategory(category);
      }
    } catch (_) {
      // Offline fallback
    }
  }
}
