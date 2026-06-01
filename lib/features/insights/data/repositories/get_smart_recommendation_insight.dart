import 'package:flutter/material.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense.dart';
import 'package:spend_wise/features/insights/domain/entities/insight_card.dart';

class GetSmartRecommendationInsight {
  InsightCard call(
    List<Expense> expenses,
    Map<String, Category> categoriesMap,
  ) {
    if (expenses.isEmpty) {
      return _emptyInsight();
    }

    final now = DateTime.now();
    final lastSevenDays = expenses
        .where((e) => e.date.isAfter(now.subtract(const Duration(days: 7))))
        .toList();
    final lastThirtyDays = expenses
        .where((e) => e.date.isAfter(now.subtract(const Duration(days: 30))))
        .toList();

    if (lastThirtyDays.isEmpty) {
      return _emptyInsight();
    }

    final dailyAvg =
        lastThirtyDays.fold<double>(0, (sum, e) => sum + e.amount) / 30;
    final sevenDayAvg =
        lastSevenDays.fold<double>(0, (sum, e) => sum + e.amount) /
        (lastSevenDays.isNotEmpty ? 7 : 1);
    final metadata = <String, String>{};
    var variant = 'on_track';
    var color = Colors.blue.value;

    if (sevenDayAvg > dailyAvg * 1.2) {
      variant = 'higher';
      color = Colors.red.value;
      metadata['percent'] = ((sevenDayAvg / dailyAvg - 1) * 100).toStringAsFixed(0);
    } else if (sevenDayAvg < dailyAvg * 0.8) {
      variant = 'lower';
      color = Colors.green.value;
    }

    final categoryName = _topCategoryName(lastSevenDays, categoriesMap);
    if (categoryName != null) {
      metadata['category'] = categoryName;
    }

    return InsightCard(
      id: 'smart_recommendation',
      title: 'Smart recommendation',
      message: 'smart_recommendation.$variant',
      type: InsightType.smart_recommendation,
      color: color,
      metadata: {'variant': variant, ...metadata},
    );
  }

  String? _topCategoryName(
    List<Expense> expenses,
    Map<String, Category> categoriesMap,
  ) {
    final totals = <String, double>{};
    for (final expense in expenses) {
      totals[expense.categoryId] = (totals[expense.categoryId] ?? 0) + expense.amount;
    }
    if (totals.isEmpty) return null;
    final topId = totals.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    return categoriesMap[topId]?.displayName;
  }

  InsightCard _emptyInsight() => InsightCard(
    id: 'smart_recommendation',
    title: 'Smart recommendation',
    message: '',
    type: InsightType.smart_recommendation,
    color: Colors.yellow.value,
  );
}
