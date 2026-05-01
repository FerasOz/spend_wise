import 'package:spend_wise/features/categories/domain/repositories/category_repository.dart';

class CanDeleteCategory {
  const CanDeleteCategory(this._categoryRepository);

  final CategoryRepository _categoryRepository;

  Future<bool> call(String categoryId) async {
    final categories = await _categoryRepository.getCategories();
    final category = categories.where((c) => c.id == categoryId).firstOrNull;

    if (category == null) {
      return false;
    }

    return !category.isDefault;
  }
}
