import '../../../expenses/domain/entities/expense.dart';
import '../../domain/entities/insight_card.dart';
import '../../domain/entities/insight_color_tokens.dart';
import 'package:spend_wise/core/services/app_clock.dart';

class GetAverageDailyInsight {
  final AppClock _clock;

  GetAverageDailyInsight({required AppClock clock}) : _clock = clock;

  InsightCard call(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return _emptyInsight();
    }

    final now = _clock.now();
    final totalThisMonth = expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .fold<double>(0, (sum, e) => sum + e.amount);
    final avgDaily = totalThisMonth / (now.day > 0 ? now.day : 1);

    if (totalThisMonth == 0) {
      return InsightCard(
        id: 'average_daily',
        title: 'Average daily',
        message: 'average_daily.no_spending',
        type: InsightType.averageDaily,
        color: InsightColorTokens.purple,
        metadata: const {'variant': 'no_spending'},
      );
    }

    return InsightCard(
      id: 'average_daily',
      title: 'Average daily',
      message: 'average_daily.current',
      type: InsightType.averageDaily,
      color: InsightColorTokens.purple,
      amount: avgDaily,
      metadata: const {'variant': 'current'},
    );
  }

  InsightCard _emptyInsight() => InsightCard(
    id: 'average_daily',
    title: 'Average daily',
    message: '',
    type: InsightType.averageDaily,
    color: InsightColorTokens.purple,
  );
}
