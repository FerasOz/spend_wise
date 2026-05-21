import 'package:flutter/material.dart';
import '../entities/insight_card.dart';
import '../../../expenses/domain/entities/expense.dart';
import '../../../categories/domain/entities/category.dart';

class GetTopCategoryInsight {
  InsightCard call(
    List<Expense> expenses,
    Map<String, Category> categoriesMap,
  ) {
    if (expenses.isEmpty) {
      return _emptyInsight();
    }

    final totals = <String, double>{};
    for (final e in expenses) {
      totals[e.categoryId] = (totals[e.categoryId] ?? 0) + e.amount;
    }

    final topId = totals.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    final amount = totals[topId]!;
    final category = categoriesMap[topId];
    final total = expenses.fold<double>(0, (sum, e) => sum + e.amount);
    final pct = (amount / total * 100).toStringAsFixed(1);

    return InsightCard(
      id: 'top_category',
      title: 'Top category',
      message:
          '${category?.name ?? 'Unknown'} is your top category at $pct% of spending.',
      type: InsightType.topCategory,
      icon: '📊',
      value: '\$${amount.toStringAsFixed(2)}',
      color: category?.color ?? Colors.blue.value,
    );
  }

  InsightCard _emptyInsight() => InsightCard(
    id: 'top_category',
    title: 'Top category',
    message: '',
    type: InsightType.topCategory,
    icon: '📊',
    color: Colors.blue.value,
  );
}
