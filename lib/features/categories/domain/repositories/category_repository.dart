import 'package:spend_wise/features/categories/domain/entities/category.dart';

abstract class CategoryRepository {

  Future<List<Category>> getCategories();
  Future<void> addCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> deleteCategory(String id);
  
}
