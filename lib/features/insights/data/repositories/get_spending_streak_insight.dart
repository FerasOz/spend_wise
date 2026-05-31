import 'package:flutter/material.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense.dart';
import 'package:spend_wise/features/insights/domain/entities/insight_card.dart';

class GetSpendingStreakInsight {
  InsightCard call(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return _emptyInsight();
    }

    final sortedExpenses = expenses.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    var streakDays = 0;
    var currentDate = _dayStart(DateTime.now());
    final spentToday = sortedExpenses.any((expense) {
      return _dayStart(expense.date).isAtSameMomentAs(currentDate);
    });

    if (spentToday) {
      streakDays = 1;
    }
    currentDate = currentDate.subtract(const Duration(days: 1));

    for (final expense in sortedExpenses) {
      final expenseDate = _dayStart(expense.date);
      if (expenseDate.isAtSameMomentAs(currentDate)) {
        streakDays++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else if (expenseDate.isBefore(currentDate)) {
        break;
      }
    }

    return InsightCard(
      id: 'spending_streak',
      title: 'Spending streak',
      message: 'spending_streak.message',
      type: InsightType.spending_streak,
      icon: 'STREAK',
      value: '$streakDays',
      color: Colors.orange.value,
      metadata: {'days': '$streakDays'},
    );
  }

  DateTime _dayStart(DateTime date) => DateTime(date.year, date.month, date.day);

  InsightCard _emptyInsight() => InsightCard(
    id: 'spending_streak',
    title: 'Spending streak',
    message: '',
    type: InsightType.spending_streak,
    icon: 'STREAK',
    color: Colors.orange.value,
  );
}
