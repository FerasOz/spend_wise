import 'package:get_it/get_it.dart';

import '../../features/insights/data/repositories/get_average_daily_insight.dart';
import '../../features/insights/data/repositories/get_highest_spending_day_insight.dart';
import '../../features/insights/data/repositories/get_smart_recommendation_insight.dart';
import '../../features/insights/data/repositories/get_spending_streak_insight.dart';
import '../../features/insights/data/repositories/get_spending_trend_insight.dart';
import '../../features/insights/data/repositories/insight_repository_impl.dart';
import '../../features/insights/domain/repositories/insight_repository.dart';
import '../../features/insights/domain/usecases/get_top_category_insight.dart';
import '../../features/insights/domain/usecases/generate_insights.dart';
import '../../features/insights/presentation/cubit/insight_cubit.dart';

Future<void> registerInsightsFeature(GetIt sl) async {
  // Insight Generators
  if (!sl.isRegistered<GetTopCategoryInsight>()) {
    sl.registerLazySingleton<GetTopCategoryInsight>(
      () => GetTopCategoryInsight(),
    );
  }

  if (!sl.isRegistered<GetSpendingTrendInsight>()) {
    sl.registerLazySingleton<GetSpendingTrendInsight>(
      () => GetSpendingTrendInsight(),
    );
  }

  if (!sl.isRegistered<GetAverageDailyInsight>()) {
    sl.registerLazySingleton<GetAverageDailyInsight>(
      () => GetAverageDailyInsight(),
    );
  }

  if (!sl.isRegistered<GetHighestSpendingDayInsight>()) {
    sl.registerLazySingleton<GetHighestSpendingDayInsight>(
      () => GetHighestSpendingDayInsight(),
    );
  }

  if (!sl.isRegistered<GetSpendingStreakInsight>()) {
    sl.registerLazySingleton<GetSpendingStreakInsight>(
      () => GetSpendingStreakInsight(),
    );
  }

  if (!sl.isRegistered<GetSmartRecommendationInsight>()) {
    sl.registerLazySingleton<GetSmartRecommendationInsight>(
      () => GetSmartRecommendationInsight(),
    );
  }

  // Insight Repository
  if (!sl.isRegistered<InsightRepository>()) {
    sl.registerLazySingleton<InsightRepository>(
      () => InsightRepositoryImpl(
        getTopCategory: sl<GetTopCategoryInsight>(),
        getTrend: sl<GetSpendingTrendInsight>(),
        getAvg: sl<GetAverageDailyInsight>(),
        getHighestDay: sl<GetHighestSpendingDayInsight>(),
        getStreak: sl<GetSpendingStreakInsight>(),
        getRecommendation: sl<GetSmartRecommendationInsight>(),
      ),
    );
  }

  // Generate Insights Use Case
  if (!sl.isRegistered<GenerateInsights>()) {
    sl.registerLazySingleton<GenerateInsights>(
      () => GenerateInsights(sl<InsightRepository>()),
    );
  }

  // Insight Cubit
  if (!sl.isRegistered<InsightCubit>()) {
    sl.registerFactory<InsightCubit>(
      () => InsightCubit(sl<GenerateInsights>()),
    );
  }
}
