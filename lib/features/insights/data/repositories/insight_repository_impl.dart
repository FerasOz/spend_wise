import 'package:spend_wise/features/insights/data/repositories/get_average_daily_insight.dart';
import 'package:spend_wise/features/insights/data/repositories/get_highest_spending_day_insight.dart';
import 'package:spend_wise/features/insights/data/repositories/get_smart_recommendation_insight.dart';
import 'package:spend_wise/features/insights/data/repositories/get_spending_streak_insight.dart';
import 'package:spend_wise/features/insights/data/repositories/get_spending_trend_insight.dart';
import 'package:spend_wise/features/insights/domain/usecases/get_top_category_insight.dart';
import '../../domain/entities/insight_card.dart';
import '../../domain/repositories/insight_repository.dart';
import '../../../expenses/domain/entities/expense.dart';
import '../../../categories/domain/entities/category.dart';

class InsightRepositoryImpl implements InsightRepository {
  const InsightRepositoryImpl({
    required GetTopCategoryInsight getTopCategory,
    required GetSpendingTrendInsight getTrend,
    required GetAverageDailyInsight getAvg,
    required GetHighestSpendingDayInsight getHighestDay,
    required GetSpendingStreakInsight getStreak,
    required GetSmartRecommendationInsight getRecommendation,
  }) : _getTopCategory = getTopCategory,
       _getTrend = getTrend,
       _getAvg = getAvg,
       _getHighestDay = getHighestDay,
       _getStreak = getStreak,
       _getRecommendation = getRecommendation;

  final GetTopCategoryInsight _getTopCategory;
  final GetSpendingTrendInsight _getTrend;
  final GetAverageDailyInsight _getAvg;
  final GetHighestSpendingDayInsight _getHighestDay;
  final GetSpendingStreakInsight _getStreak;
  final GetSmartRecommendationInsight _getRecommendation;

  @override
  List<InsightCard> generateInsights(
    List<Expense> expenses,
    Map<String, Category> categoriesMap,
  ) {
    if (expenses.isEmpty) return [];

    return [
      _getTopCategory(expenses, categoriesMap),
      _getTrend(expenses),
      _getAvg(expenses),
      _getHighestDay(expenses),
      _getStreak(expenses),
      _getRecommendation(expenses, categoriesMap),
    ].where((insight) => insight.message.isNotEmpty).toList();
  }

  @override
  InsightCard getTopCategoryInsight(
    List<Expense> expenses,
    Map<String, Category> map,
  ) => _getTopCategory(expenses, map);
  @override
  InsightCard getSpendingTrendInsight(List<Expense> expenses) =>
      _getTrend(expenses);
  @override
  InsightCard getAverageDailyInsight(List<Expense> expenses) =>
      _getAvg(expenses);
  @override
  InsightCard getHighestSpendingDayInsight(List<Expense> expenses) =>
      _getHighestDay(expenses);
  @override
  InsightCard getSpendingStreakInsight(List<Expense> expenses) =>
      _getStreak(expenses);
  @override
  InsightCard getSmartRecommendationInsight(
    List<Expense> expenses,
    Map<String, Category> map,
  ) => _getRecommendation(expenses, map);
}
