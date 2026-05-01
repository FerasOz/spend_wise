import 'package:hive/hive.dart';
import 'package:spend_wise/features/categories/data/models/category_model.dart';

abstract class CategoryLocalDataSource {
  Future<void> addCategory(CategoryModel category);

  Future<List<CategoryModel>> getCategories();

  Future<void> updateCategory(CategoryModel category);

  Future<void> deleteCategory(String id);
}

class HiveCategoryLocalDataSource implements CategoryLocalDataSource {
  HiveCategoryLocalDataSource(this._box);

  static const String boxName = 'categories_box';

  final Box<Map> _box;

  @override
  Future<void> addCategory(CategoryModel category) async {
    await _box.put(category.id, category.toJson());
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    return _box.values
        .map(
          (categoryMap) =>
              CategoryModel.fromJson(Map<String, dynamic>.from(categoryMap)),
        )
        .toList(growable: false);
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    await _box.put(category.id, category.toJson());
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _box.delete(id);
  }
}
