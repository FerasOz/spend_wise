import 'package:flutter/material.dart';
import 'package:spend_wise/features/insights/domain/entities/insight_card.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense.dart';

class GetSpendingTrendInsight {
  InsightCard call(List<Expense> expenses) {
    if (expenses.length < 2) {
      return _emptyInsight();
    }

    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    final previousMonth = DateTime(now.year, now.month - 1);

    final currentMonthSpending = expenses
        .where(
          (e) =>
              e.date.year == currentMonth.year &&
              e.date.month == currentMonth.month,
        )
        .fold<double>(0, (sum, e) => sum + e.amount);

    final previousMonthSpending = expenses
        .where(
          (e) =>
              e.date.year == previousMonth.year &&
              e.date.month == previousMonth.month,
        )
        .fold<double>(0, (sum, e) => sum + e.amount);

    if (previousMonthSpending == 0) {
      // If no spending last month, we can't calculate a trend.
      // Or if current month spending is also 0, it's not a trend.
      if (currentMonthSpending == 0) return _emptyInsight();
      // If previous month spending is 0 but current month has spending, it's a significant increase.
      return InsightCard(
        id: 'spending_trend',
        title: 'Spending trend',
        message: 'You started spending this month! Keep an eye on it. 📈',
        type: InsightType.spending_trend,
        icon: '📈',
        color: Colors.green.value,
      );
    }

    final delta =
        ((currentMonthSpending - previousMonthSpending) /
        previousMonthSpending *
        100);
    final direction = delta >= 0 ? 'up' : 'down';
    final message =
        'Your spending is $direction ${delta.abs().toStringAsFixed(1)}% compared to last month.';

    return InsightCard(
      id: 'spending_trend',
      title: 'Spending trend',
      message: message,
      type: InsightType.spending_trend,
      icon: '📈',
      value: '${delta > 0 ? '+' : ''}${delta.toStringAsFixed(1)}%',
      color: delta >= 0 ? Colors.orange.value : Colors.green.value,
    );
  }

  InsightCard _emptyInsight() => InsightCard(
    id: 'spending_trend',
    title: 'Spending trend',
    message: '',
    type: InsightType.spending_trend,
    icon: '📈',
    color: Colors.green.value,
  );
}
