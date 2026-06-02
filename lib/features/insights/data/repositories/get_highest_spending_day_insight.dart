import '../../../expenses/domain/entities/expense.dart';
import '../../domain/entities/insight_card.dart';
import '../../domain/entities/insight_color_tokens.dart';

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
      message: 'highest_spending_day.message',
      type: InsightType.highestSpendingDay,
      color: InsightColorTokens.red,
      amount: highestDay.value,
      metadata: {'day': _dayValue(highestDay.key)},
    );
  }

  InsightCard _emptyInsight() => InsightCard(
    id: 'highest_spending_day',
    title: 'Highest spending day',
    message: '',
    type: InsightType.highestSpendingDay,
    color: InsightColorTokens.red,
  );

  String _dayValue(DateTime date) {
    return date.toIso8601String();
  }
}
