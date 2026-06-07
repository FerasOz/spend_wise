import 'package:spend_wise/features/expenses/domain/entities/expense.dart';
import 'package:spend_wise/features/insights/domain/entities/insight_color_tokens.dart';
import 'package:spend_wise/features/insights/domain/entities/insight_card.dart';
import 'package:spend_wise/core/services/app_clock.dart';

class GetSpendingStreakInsight {
  final AppClock _clock;

  GetSpendingStreakInsight({required AppClock clock}) : _clock = clock;

  InsightCard call(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return _emptyInsight();
    }

    final sortedExpenses = expenses.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    var streakDays = 0;
    var currentDate = _dayStart(_clock.now());
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
      type: InsightType.spendingStreak,
      value: '$streakDays',
      color: InsightColorTokens.orange,
      metadata: {'days': '$streakDays'},
    );
  }

  DateTime _dayStart(DateTime date) => DateTime(date.year, date.month, date.day);

  InsightCard _emptyInsight() => InsightCard(
    id: 'spending_streak',
    title: 'Spending streak',
    message: '',
    type: InsightType.spendingStreak,
    color: InsightColorTokens.orange,
  );
}
