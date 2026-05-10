import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/dashboard/domain/entities/category_spending.dart';
import 'package:spend_wise/features/dashboard/domain/entities/dashboard_source_data.dart';

class GetTopCategories {
  const GetTopCategories();

  List<CategorySpending> call(
    DashboardSourceData sourceData, {
    int limit = 4,
  }) {
    final categoriesById = {
      for (final category in sourceData.categories) category.id: category,
    };
    final totalsByCategoryId = <String, double>{};

    for (final expense in sourceData.expenses) {
      totalsByCategoryId.update(
        expense.categoryId,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    final totalSpending = totalsByCategoryId.values.fold<double>(
      0,
      (sum, amount) => sum + amount,
    );

    final results = totalsByCategoryId.entries
        .map((entry) {
          final category = categoriesById[entry.key] ?? _fallbackCategory(entry.key);
          final percentage = totalSpending == 0
              ? 0.0
              : entry.value / totalSpending;

          return CategorySpending(
            category: category,
            amount: entry.value,
            percentage: percentage,
          );
        })
        .toList(growable: false)
      ..sort((first, second) => second.amount.compareTo(first.amount));

    return results.take(limit).toList(growable: false);
  }

  Category _fallbackCategory(String categoryId) {
    return Category(
      id: categoryId,
      name: 'Unknown Category',
      icon: 'shopping_cart',
      color: 0xFFFF6B6B,
      isDefault: false,
      createdAt: DateTime.now(),
    );
  }
}
