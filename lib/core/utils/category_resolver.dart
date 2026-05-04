import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/categories/presentation/utils/category_presentation_data.dart';

/// Utility class to resolve categoryId to Category object.
/// Handles fallback scenarios when a category is missing or not found.
class CategoryResolver {
  /// Creates a fallback category when the category ID is not found.
  /// This ensures the UI doesn't break when a category is deleted
  /// but expenses still reference it.
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

  /// Resolves a categoryId to a Category object from the provided list.
  /// Returns a fallback category if the categoryId is not found.
  ///
  /// Parameters:
  /// - [categoryId]: The ID of the category to find
  /// - [categories]: List of available categories
  ///
  /// Returns: The matching Category or a fallback category
  static Category resolveCategory(
    String categoryId,
    List<Category> categories,
  ) {
    try {
      return categories.firstWhere((cat) => cat.id == categoryId);
    } catch (e) {
      return createFallbackCategory(categoryId);
    }
  }

  /// Batch resolves multiple category IDs to Category objects.
  /// Useful for efficiently resolving categories for entire expense lists.
  ///
  /// Parameters:
  /// - [categoryIds]: List of category IDs to resolve
  /// - [categories]: List of available categories
  ///
  /// Returns: Map of categoryId → Category with fallbacks for missing categories
  static Map<String, Category> resolveCategoriesBatch(
    List<String> categoryIds,
    List<Category> categories,
  ) {
    final categoryMap = <String, Category>{};

    for (final categoryId in categoryIds) {
      if (!categoryMap.containsKey(categoryId)) {
        categoryMap[categoryId] = resolveCategory(categoryId, categories);
      }
    }

    return categoryMap;
  }

  /// Creates a category from raw data (used when migrating from text-based categories).
  /// This helps transition from manual text input to structured categories.
  static Category createCategoryFromText(
    String categoryName, {
    String? id,
    int? color,
    String? icon,
  }) {
    return Category(
      id: id ?? categoryName.toLowerCase(),
      name: categoryName,
      icon: icon ?? CategoryPresentationData.defaultIconName,
      color: color ?? CategoryPresentationData.defaultColorValue,
      isDefault: false,
      createdAt: DateTime.now(),
    );
  }
}
