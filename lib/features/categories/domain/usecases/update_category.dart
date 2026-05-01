import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/categories/domain/repositories/category_repository.dart';

class UpdateCategory {
  const UpdateCategory(this._categoryRepository);

  final CategoryRepository _categoryRepository;

  Future<void> call(Category category) {
    return _categoryRepository.updateCategory(category);
  }
}
