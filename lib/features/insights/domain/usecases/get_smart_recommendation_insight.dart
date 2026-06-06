import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense.dart';
import 'package:spend_wise/features/insights/domain/entities/insight_color_tokens.dart';
import 'package:spend_wise/features/insights/domain/entities/insight_card.dart';
import 'package:spend_wise/core/services/app_clock.dart';

class GetSmartRecommendationInsight {
  final AppClock _clock;

  GetSmartRecommendationInsight({required AppClock clock}) : _clock = clock;

  InsightCard call(
    List<Expense> expenses,
    Map<String, Category> categoriesMap,
  ) {
    if (expenses.isEmpty) {
      return _emptyInsight();
    }

    final now = _clock.now();
    final lastSevenDays = expenses
        .where((e) => e.date.isAfter(now.subtract(const Duration(days: 7))))
        .toList();
    final lastThirtyDays = expenses
        .where((e) => e.date.isAfter(now.subtract(const Duration(days: 30))))
        .toList();

    if (lastThirtyDays.isEmpty) {
      return _emptyInsight();
    }

    final dailyAvg =
        lastThirtyDays.fold<double>(0, (sum, e) => sum + e.amount) / 30;
    final sevenDayAvg =
        lastSevenDays.fold<double>(0, (sum, e) => sum + e.amount) /
        (lastSevenDays.isNotEmpty ? 7 : 1);
    final metadata = <String, String>{};
    var variant = 'on_track';
    var color = InsightColorTokens.blue;

    if (sevenDayAvg > dailyAvg * 1.2) {
      variant = 'higher';
      color = InsightColorTokens.red;
      metadata['percent'] = ((sevenDayAvg / dailyAvg - 1) * 100).toStringAsFixed(0);
    } else if (sevenDayAvg < dailyAvg * 0.8) {
      variant = 'lower';
      color = InsightColorTokens.green;
    }

    final categoryName = _topCategoryName(lastSevenDays, categoriesMap);
    if (categoryName != null) {
      metadata.addAll(categoryName);
    }

    return InsightCard(
      id: 'smart_recommendation',
      title: 'Smart recommendation',
      message: 'smart_recommendation.$variant',
      type: InsightType.smartRecommendation,
      color: color,
      metadata: {'variant': variant, ...metadata},
    );
  }

  Map<String, String>? _topCategoryName(
    List<Expense> expenses,
    Map<String, Category> categoriesMap,
  ) {
    final totals = <String, double>{};
    for (final expense in expenses) {
      totals[expense.categoryId] = (totals[expense.categoryId] ?? 0) + expense.amount;
    }
    if (totals.isEmpty) return null;
    final topId = totals.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    final category = categoriesMap[topId];
    if (category == null) return null;
    return {'category': category.name, 'categoryId': category.id};
  }

  InsightCard _emptyInsight() => InsightCard(
    id: 'smart_recommendation',
    title: 'Smart recommendation',
    message: '',
    type: InsightType.smartRecommendation,
    color: InsightColorTokens.yellow,
  );
}
