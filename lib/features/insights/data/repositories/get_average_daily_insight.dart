import 'package:flutter/material.dart';

import '../../../expenses/domain/entities/expense.dart';
import '../../domain/entities/insight_card.dart';

class GetAverageDailyInsight {
  InsightCard call(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return _emptyInsight();
    }

    final now = DateTime.now();
    final totalThisMonth = expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .fold<double>(0, (sum, e) => sum + e.amount);
    final avgDaily = totalThisMonth / (now.day > 0 ? now.day : 1);

    if (totalThisMonth == 0) {
      return InsightCard(
        id: 'average_daily',
        title: 'Average daily',
        message: 'average_daily.no_spending',
        type: InsightType.average_daily,
        icon: 'AVG',
        color: Colors.purple.value,
        metadata: const {'variant': 'no_spending'},
      );
    }

    return InsightCard(
      id: 'average_daily',
      title: 'Average daily',
      message: 'average_daily.current',
      type: InsightType.average_daily,
      icon: 'AVG',
      color: Colors.purple.value,
      amount: avgDaily,
      metadata: const {'variant': 'current'},
    );
  }

  InsightCard _emptyInsight() => InsightCard(
    id: 'average_daily',
    title: 'Average daily',
    message: '',
    type: InsightType.average_daily,
    icon: 'AVG',
    color: Colors.purple.value,
  );
}
