import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/categories/domain/repositories/category_repository.dart';

class GetCategories {
  const GetCategories(this._categoryRepository);

  final CategoryRepository _categoryRepository;

  Future<List<Category>> call() {
    return _categoryRepository.getCategories();
  }
}
