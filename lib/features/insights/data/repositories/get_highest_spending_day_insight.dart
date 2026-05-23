import 'package:flutter/material.dart';

import '../../../expenses/domain/entities/expense.dart';
import '../../domain/entities/insight_card.dart';

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

    final highestDay = dailyTotals.entries.reduce((a, b) {
      return a.value > b.value ? a : b;
    });

    return InsightCard(
      id: 'highest_spending_day',
      title: 'Highest spending day',
      message: 'Your highest spending happened on ${_dayName(highestDay.key)}.',
      type: InsightType.highest_spending_day,
      icon: 'DAY',
      color: Colors.red.value,
      amount: highestDay.value,
    );
  }

  InsightCard _emptyInsight() => InsightCard(
    id: 'highest_spending_day',
    title: 'Highest spending day',
    message: '',
    type: InsightType.highest_spending_day,
    icon: 'DAY',
    color: Colors.red.value,
  );

  String _dayName(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
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
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
  }
}
