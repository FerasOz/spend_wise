import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/categories/presentation/utils/category_presentation_data.dart';

/// Utility class to resolve categoryId to Category object.
/// Handles fallback scenarios when a category is missing or not found.
class CategoryResolver {
  const CategoryResolver._();

  static Category createFallbackCategory(String categoryId) {
    return Category(
      id: categoryId,
      name: 'Unknown Category',
      icon: CategoryPresentationData.defaultIconName,
      color: CategoryPresentationData.defaultColorValue,
      isDefault: false,
      createdAt: DateTime.now(),
    );
  }

  static Category resolveCategory(
    String categoryId,
    List<Category> categories,
  ) {
    return resolveCategoryFromMap(categoryId, indexCategories(categories));
  }

  static Map<String, Category> indexCategories(List<Category> categories) {
    return {
      for (final category in categories) category.id: category,
    };
  }

  static Category resolveCategoryFromMap(
    String categoryId,
    Map<String, Category> categoriesById,
  ) {
    return categoriesById[categoryId] ?? createFallbackCategory(categoryId);
  }

  static Map<String, Category> resolveCategoriesBatch(
    List<String> categoryIds,
    List<Category> categories,
  ) {
    final categoriesById = indexCategories(categories);
    final categoryMap = <String, Category>{};

    for (final categoryId in categoryIds) {
      if (!categoryMap.containsKey(categoryId)) {
        categoryMap[categoryId] = resolveCategoryFromMap(
          categoryId,
          categoriesById,
        );
      }
    }

    return categoryMap;
  }
}
