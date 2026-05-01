import 'package:spend_wise/features/categories/data/datasources/category_local_data_source.dart';
import 'package:spend_wise/features/categories/data/models/category_model.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/categories/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl(this._localDataSource);

  final CategoryLocalDataSource _localDataSource;

  @override
  Future<void> addCategory(Category category) {
    final categoryModel = CategoryModel.fromEntity(category);
    return _localDataSource.addCategory(categoryModel);
  }

  @override
  Future<void> deleteCategory(String id) {
    return _localDataSource.deleteCategory(id);
  }

  @override
  Future<List<Category>> getCategories() {
    return _localDataSource.getCategories().then((categoryModels) {
      return categoryModels
          .map((categoryModel) => categoryModel.toEntity())
          .toList(growable: false);
    });
  }

  @override
  Future<void> updateCategory(Category category) {
    final categoryModel = CategoryModel.fromEntity(category);
    return _localDataSource.updateCategory(categoryModel);
  }
}
