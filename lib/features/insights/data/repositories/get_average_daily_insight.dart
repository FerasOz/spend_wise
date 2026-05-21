import 'package:flutter/material.dart';
import 'package:spend_wise/features/insights/domain/entities/insight_card.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense.dart';

class GetAverageDailyInsight {
  InsightCard call(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return _emptyInsight();
    }

    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(
      now.year,
      now.month + 1,
      0,
    ).day; // Get last day of current month

    final totalThisMonth = expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .fold<double>(0, (sum, e) => sum + e.amount);

    // Calculate average based on days passed in the month, not total days in month,
    // unless it's the end of the month.
    final daysPassed = now.day;
    final effectiveDays = daysPassed > 0
        ? daysPassed
        : 1; // Avoid division by zero

    final avgDaily = totalThisMonth / effectiveDays;

    if (totalThisMonth == 0) {
      return InsightCard(
        id: 'average_daily',
        title: 'Average daily',
        message: 'No spending recorded this month yet. Keep it up! 💰',
        type: InsightType.average_daily,
        icon: '💰',
        color: Colors.purple.value,
      );
    }

    return InsightCard(
      id: 'average_daily',
      title: 'Average daily',
      message:
          'You\'re spending an average of \$${avgDaily.toStringAsFixed(2)} per day this month.',
      type: InsightType.average_daily,
      icon: '💰',
      value: '\$${avgDaily.toStringAsFixed(2)}',
      color: Colors.purple.value,
    );
  }

  InsightCard _emptyInsight() => InsightCard(
    id: 'average_daily',
    title: 'Average daily',
    message: '',
    type: InsightType.average_daily,
    icon: '💰',
    color: Colors.purple.value,
  );
}
