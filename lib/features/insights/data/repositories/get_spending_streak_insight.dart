import 'package:flutter/material.dart';
import 'package:spend_wise/features/insights/domain/entities/insight_card.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense.dart';

class GetSpendingStreakInsight {
  InsightCard call(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return _emptyInsight();
    }

    final now = DateTime.now();
    final sortedExpenses = expenses.toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    var streakDays = 0;
    var currentDate = DateTime(now.year, now.month, now.day);

    // Check if today has an expense
    bool spentToday = sortedExpenses.any(
      (e) =>
          e.date.year == currentDate.year &&
          e.date.month == currentDate.month &&
          e.date.day == currentDate.day,
    );

    if (spentToday) {
      streakDays = 1;
      currentDate = currentDate.subtract(const Duration(days: 1));
    } else {
      // If no spending today, check from yesterday backwards
      currentDate = currentDate.subtract(const Duration(days: 1));
    }

    for (final expense in sortedExpenses) {
      final expenseDate = DateTime(
        expense.date.year,
        expense.date.month,
        expense.date.day,
      );
      if (expenseDate.isAtSameMomentAs(currentDate)) {
        streakDays++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else if (expenseDate.isBefore(currentDate)) {
        break; // Gap in spending, streak broken
      }
    }

    return InsightCard(
      id: 'spending_streak',
      title: 'Spending streak',
      message:
          'You have spent on $streakDays consecutive days. Keep the momentum! 🎯',
      type: InsightType.spending_streak,
      icon: '🔥',
      value: '$streakDays days',
      color: Colors.orange.value,
    );
  }

  InsightCard _emptyInsight() => InsightCard(
    id: 'spending_streak',
    title: 'Spending streak',
    message: '',
    type: InsightType.spending_streak,
    icon: '🔥',
    color: Colors.orange.value,
  );
}
