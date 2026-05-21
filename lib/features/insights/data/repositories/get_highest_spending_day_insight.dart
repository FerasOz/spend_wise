import 'package:flutter/material.dart';
import 'package:spend_wise/features/insights/domain/entities/insight_card.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense.dart';

class GetHighestSpendingDayInsight {
  InsightCard call(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return _emptyInsight();
    }

    final dailyTotals = <DateTime, double>{};
    for (final expense in expenses) {
      final dayStart = DateTime(
        expense.date.year,
        expense.date.month,
        expense.date.day,
      );
      dailyTotals[dayStart] = (dailyTotals[dayStart] ?? 0) + expense.amount;
    }

    final highestDay = dailyTotals.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );
    final dayName = _getDayName(highestDay.key);
    final amount = highestDay.value;

    return InsightCard(
      id: 'highest_spending_day',
      title: 'Highest spending day',
      message:
          'Your highest spending was $dayName with \$${amount.toStringAsFixed(2)}.',
      type: InsightType.highest_spending_day,
      icon: '🔥',
      value: '\$${amount.toStringAsFixed(2)}',
      color: Colors.red.value,
    );
  }

  InsightCard _emptyInsight() => InsightCard(
    id: 'highest_spending_day',
    title: 'Highest spending day',
    message: '',
    type: InsightType.highest_spending_day,
    icon: '🔥',
    color: Colors.red.value,
  );

  String _getDayName(DateTime date) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[date.weekday - 1]}, ${date.day} ${_getMonthName(date.month)}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
