import 'package:spend_wise/features/categories/domain/repositories/category_repository.dart';

class DeleteCategory {
  const DeleteCategory(this._categoryRepository);

  final CategoryRepository _categoryRepository;

  Future<void> call(String id) {
    return _categoryRepository.deleteCategory(id);
  }
}
