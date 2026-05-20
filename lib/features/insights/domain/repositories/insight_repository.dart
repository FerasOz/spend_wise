import '../entities/insight_card.dart';
import '../../../expenses/domain/entities/expense.dart';
import '../../../categories/domain/entities/category.dart';

abstract class InsightRepository {
  List<InsightCard> generateInsights(
    List<Expense> expenses,
    Map<String, Category> categoriesMap,
  );

  InsightCard getTopCategoryInsight(
    List<Expense> expenses,
    Map<String, Category> categoriesMap,
  );

  InsightCard getSpendingTrendInsight(List<Expense> expenses);

  InsightCard getAverageDailyInsight(List<Expense> expenses);

  InsightCard getHighestSpendingDayInsight(List<Expense> expenses);

  InsightCard getSpendingStreakInsight(List<Expense> expenses);

  InsightCard getSmartRecommendationInsight(
    List<Expense> expenses,
    Map<String, Category> categoriesMap,
  );
}
