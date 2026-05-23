import 'package:flutter/material.dart';
import 'package:spend_wise/features/insights/domain/entities/insight_card.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';

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

    String message;
    int color = Colors.yellow.value;

    if (sevenDayAvg > dailyAvg * 1.2) {
      message =
          'Your spending is ${((sevenDayAvg / dailyAvg - 1) * 100).toStringAsFixed(0)}% higher this week. '
          'Consider reviewing your expenses.';
      color = Colors.red.value;
    } else if (sevenDayAvg < dailyAvg * 0.8) {
      message =
          'Great job! You\'re spending less this week. Keep up the good work!';
      color = Colors.green.value;
    } else {
      message = 'Your spending is on track with your average. Stay consistent!';
      color = Colors.blue.value;
    }

    // Additional recommendation: identify a high-spending category in the last 7 days
    if (lastSevenDays.isNotEmpty) {
      final categoryTotalsLast7Days = <String, double>{};
      for (final expense in lastSevenDays) {
        categoryTotalsLast7Days[expense.categoryId] =
            (categoryTotalsLast7Days[expense.categoryId] ?? 0) + expense.amount;
      }
      if (categoryTotalsLast7Days.isNotEmpty) {
        final topCategoryLast7Days = categoryTotalsLast7Days.entries
            .reduce((a, b) => a.value > b.value ? a : b)
            .key;
        final categoryName = categoriesMap[topCategoryLast7Days]?.name ?? 'a category';
        message += '\nConsider reducing spending on "$categoryName" this week.';
      }
    }

    return InsightCard(
      id: 'smart_recommendation',
      title: 'Smart recommendation',
      message: message,
      type: InsightType.smart_recommendation,
      icon: '💡',
      color: color,
    );
  }

  InsightCard _emptyInsight() => InsightCard(id: 'smart_recommendation', title: 'Smart recommendation', message: '', type: InsightType.smart_recommendation, icon: '💡', color: Colors.yellow.value);
}