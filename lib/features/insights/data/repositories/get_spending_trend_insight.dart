import 'package:spend_wise/features/expenses/domain/entities/expense.dart';
import 'package:spend_wise/features/insights/domain/entities/insight_color_tokens.dart';
import 'package:spend_wise/features/insights/domain/entities/insight_card.dart';

class GetSpendingTrendInsight {
  InsightCard call(List<Expense> expenses) {
    if (expenses.length < 2) {
      return _emptyInsight();
    }

    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    final previousMonth = DateTime(now.year, now.month - 1);
    final currentMonthSpending = _monthTotal(expenses, currentMonth);
    final previousMonthSpending = _monthTotal(expenses, previousMonth);

    if (previousMonthSpending == 0) {
      if (currentMonthSpending == 0) return _emptyInsight();
      return InsightCard(
        id: 'spending_trend',
        title: 'Spending trend',
        message: 'spending_trend.started',
        type: InsightType.spendingTrend,
        color: InsightColorTokens.green,
        metadata: const {'variant': 'started'},
      );
    }

    final delta =
        ((currentMonthSpending - previousMonthSpending) / previousMonthSpending) *
        100;
    final variant = delta >= 0 ? 'increased' : 'decreased';

    return InsightCard(
      id: 'spending_trend',
      title: 'Spending trend',
      message: 'spending_trend.$variant',
      type: InsightType.spendingTrend,
      value: '${delta > 0 ? '+' : ''}${delta.toStringAsFixed(1)}%',
      color: delta >= 0 ? InsightColorTokens.orange : InsightColorTokens.green,
      metadata: {
        'variant': variant,
        'percent': delta.abs().toStringAsFixed(1),
      },
    );
  }

  double _monthTotal(List<Expense> expenses, DateTime month) {
    return expenses
        .where((e) => e.date.year == month.year && e.date.month == month.month)
        .fold<double>(0, (sum, e) => sum + e.amount);
  }

  InsightCard _emptyInsight() => InsightCard(
    id: 'spending_trend',
    title: 'Spending trend',
    message: '',
    type: InsightType.spendingTrend,
    color: InsightColorTokens.green,
  );
}
