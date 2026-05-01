import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/categories/domain/repositories/category_repository.dart';

class AddCategory {
  const AddCategory(this._categoryRepository);

  final CategoryRepository _categoryRepository;

  Future<void> call(Category category) {
    return _categoryRepository.addCategory(category);
  }
}
