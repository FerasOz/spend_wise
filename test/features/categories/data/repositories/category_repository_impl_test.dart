import 'package:flutter_test/flutter_test.dart';
import 'package:spend_wise/features/categories/data/datasources/category_local_data_source.dart';
import 'package:spend_wise/features/categories/data/datasources/category_remote_data_source.dart';
import 'package:spend_wise/features/categories/data/models/category_model.dart';
import 'package:spend_wise/features/categories/data/repositories/category_repository_impl.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';

void main() {
  group('CategoryRepositoryImpl', () {
    late SpyCategoryLocalDataSource localDataSource;
    late SpyCategoryRemoteDataSource remoteDataSource;
    late CategoryRepositoryImpl repository;

    final tCategory = Category(
      id: 'cat_1',
      name: 'Food',
      icon: 'restaurant',
      color: 0xFF4CAF50,
      isDefault: true,
      createdAt: DateTime(2026, 6, 11),
    );

    setUp(() {
      localDataSource = SpyCategoryLocalDataSource();
      remoteDataSource = SpyCategoryRemoteDataSource();
      repository = CategoryRepositoryImpl(localDataSource, remoteDataSource);
    });

    test('addCategory should write to local and remote', () async {
      await repository.addCategory(tCategory);

      expect(localDataSource.addCategoryCalled, true);
      expect(remoteDataSource.addCategoryCalled, true);
      expect(localDataSource.categories.first.id, 'cat_1');
      expect(remoteDataSource.categories.first.id, 'cat_1');
    });

    test('addCategory should swallow remote exceptions (offline fallback)', () async {
      remoteDataSource.shouldThrow = true;

      await expectLater(repository.addCategory(tCategory), completes);

      expect(localDataSource.addCategoryCalled, true);
      expect(remoteDataSource.addCategoryCalled, true);
      expect(localDataSource.categories.first.id, 'cat_1');
      expect(remoteDataSource.categories, isEmpty);
    });

    test('updateCategory should update both local and remote', () async {
      await repository.addCategory(tCategory);
      final updated = tCategory.copyWith(name: 'Groceries');

      await repository.updateCategory(updated);

      expect(localDataSource.updateCategoryCalled, true);
      expect(remoteDataSource.updateCategoryCalled, true);
      expect(localDataSource.categories.first.name, 'Groceries');
      expect(remoteDataSource.categories.first.name, 'Groceries');
    });

    test('updateCategory should not throw when remote throws', () async {
      await repository.addCategory(tCategory);
      final updated = tCategory.copyWith(name: 'Groceries');
      remoteDataSource.shouldThrow = true;

      await expectLater(repository.updateCategory(updated), completes);

      expect(localDataSource.updateCategoryCalled, true);
      expect(localDataSource.categories.first.name, 'Groceries');
      expect(remoteDataSource.categories.first.name, 'Food');
    });

    test('deleteCategory should delete from both local and remote', () async {
      await repository.addCategory(tCategory);

      await repository.deleteCategory('cat_1');

      expect(localDataSource.deleteCategoryCalled, true);
      expect(remoteDataSource.deleteCategoryCalled, true);
      expect(localDataSource.categories, isEmpty);
      expect(remoteDataSource.categories, isEmpty);
    });

    test('deleteCategory should not throw when remote throws', () async {
      await repository.addCategory(tCategory);
      remoteDataSource.shouldThrow = true;

      await expectLater(repository.deleteCategory('cat_1'), completes);

      expect(localDataSource.deleteCategoryCalled, true);
      expect(localDataSource.categories, isEmpty);
      expect(remoteDataSource.categories.first.id, 'cat_1');
    });

    test('getCategories should pull from remote to local cache and return results', () async {
      remoteDataSource.categories.add(CategoryModel.fromEntity(tCategory));

      final result = await repository.getCategories();

      expect(remoteDataSource.getCategoriesCalled, true);
      expect(localDataSource.categories.first.id, 'cat_1');
      expect(result.first.id, 'cat_1');
    });

    test('getCategories should fallback to local when remote throws', () async {
      localDataSource.categories.add(CategoryModel.fromEntity(tCategory));
      remoteDataSource.shouldThrow = true;

      final result = await repository.getCategories();

      expect(remoteDataSource.getCategoriesCalled, true);
      expect(result.first.id, 'cat_1');
    });
  });
}

class SpyCategoryLocalDataSource implements CategoryLocalDataSource {
  final List<CategoryModel> categories = [];
  bool addCategoryCalled = false;
  bool getCategoriesCalled = false;
  bool updateCategoryCalled = false;
  bool deleteCategoryCalled = false;

  @override
  Future<void> addCategory(CategoryModel category) async {
    addCategoryCalled = true;
    categories.add(category);
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    getCategoriesCalled = true;
    return categories;
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    updateCategoryCalled = true;
    final idx = categories.indexWhere((c) => c.id == category.id);
    if (idx != -1) {
      categories[idx] = category;
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    deleteCategoryCalled = true;
    categories.removeWhere((c) => c.id == id);
  }
}

class SpyCategoryRemoteDataSource implements CategoryRemoteDataSource {
  final List<CategoryModel> categories = [];
  bool addCategoryCalled = false;
  bool getCategoriesCalled = false;
  bool updateCategoryCalled = false;
  bool deleteCategoryCalled = false;
  bool shouldThrow = false;

  @override
  Future<void> addCategory(CategoryModel category) async {
    addCategoryCalled = true;
    if (shouldThrow) throw Exception('Network error');
    categories.add(category);
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    getCategoriesCalled = true;
    if (shouldThrow) throw Exception('Network error');
    return categories;
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    updateCategoryCalled = true;
    if (shouldThrow) throw Exception('Network error');
    final idx = categories.indexWhere((c) => c.id == category.id);
    if (idx != -1) {
      categories[idx] = category;
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    deleteCategoryCalled = true;
    if (shouldThrow) throw Exception('Network error');
    categories.removeWhere((c) => c.id == id);
  }
}
