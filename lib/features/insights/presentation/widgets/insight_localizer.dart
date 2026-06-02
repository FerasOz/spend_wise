import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

import '../../domain/entities/insight_card.dart';

class InsightLocalizer {
  const InsightLocalizer._();

  static String title(InsightCard insight) => _titleKey(insight.type).tr();

  static String message(BuildContext context, InsightCard insight) {
    final args = Map<String, String>.from(insight.metadata);
    final day = _localizedDay(context, args['day']);
    if (day != null) args['day'] = day;
    final category = _localizedCategory(args['categoryId'], args['category']);
    if (category != null) args['category'] = category;

    final key = switch (insight.type) {
      InsightType.spendingTrend => _spendingTrendKey(args['variant']),
      InsightType.averageDaily => _averageDailyKey(args['variant']),
      InsightType.smartRecommendation => _smartRecommendationKey(args['variant']),
      _ => _messageKey(insight.type),
    };

    final message = key.tr(namedArgs: args);
    final categoryName = args['category'];
    if (insight.type == InsightType.smartRecommendation && categoryName != null) {
      final reduceCategory =
          LocaleKeys.dashboard_insights_cards_smartRecommendation_reduceCategory
              .tr(namedArgs: {'category': categoryName});
      return '$message\n$reduceCategory';
    }
    return message;
  }

  static String value(InsightCard insight) {
    if (insight.type == InsightType.spendingStreak) {
      return LocaleKeys.dashboard_insights_cards_spendingStreak_value.tr(
        namedArgs: {'days': insight.metadata['days'] ?? insight.value ?? '0'},
      );
    }
    return insight.value ?? '';
  }

  static String? _localizedDay(BuildContext context, String? rawDay) {
    final date = rawDay == null ? null : DateTime.tryParse(rawDay);
    if (date == null) return null;
    return MaterialLocalizations.of(context).formatShortDate(date);
  }

  static String? _localizedCategory(String? categoryId, String? fallback) {
    return switch (categoryId) {
      'cat_shopping' => LocaleKeys.categories_defaultCategories_shopping.tr(),
      'cat_food' => LocaleKeys.categories_defaultCategories_food.tr(),
      'cat_transport' =>
        LocaleKeys.categories_defaultCategories_transportation.tr(),
      'cat_entertainment' =>
        LocaleKeys.categories_defaultCategories_entertainment.tr(),
      'cat_utilities' => LocaleKeys.categories_defaultCategories_utilities.tr(),
      'cat_health' => LocaleKeys.categories_defaultCategories_health.tr(),
      _ => fallback,
    };
  }

  static String _titleKey(InsightType type) {
    return switch (type) {
      InsightType.topCategory => LocaleKeys.dashboard_insights_cards_topCategory_title,
      InsightType.spendingTrend => LocaleKeys.dashboard_insights_cards_spendingTrend_title,
      InsightType.averageDaily => LocaleKeys.dashboard_insights_cards_averageDaily_title,
      InsightType.highestSpendingDay =>
        LocaleKeys.dashboard_insights_cards_highestSpendingDay_title,
      InsightType.spendingStreak => LocaleKeys.dashboard_insights_cards_spendingStreak_title,
      InsightType.smartRecommendation =>
        LocaleKeys.dashboard_insights_cards_smartRecommendation_title,
    };
  }

  static String _messageKey(InsightType type) {
    return switch (type) {
      InsightType.topCategory => LocaleKeys.dashboard_insights_cards_topCategory_message,
      InsightType.highestSpendingDay =>
        LocaleKeys.dashboard_insights_cards_highestSpendingDay_message,
      InsightType.spendingStreak => LocaleKeys.dashboard_insights_cards_spendingStreak_message,
      _ => '',
    };
  }

  static String _spendingTrendKey(String? variant) {
    return switch (variant) {
      'started' => LocaleKeys.dashboard_insights_cards_spendingTrend_started,
      'decreased' => LocaleKeys.dashboard_insights_cards_spendingTrend_decreased,
      _ => LocaleKeys.dashboard_insights_cards_spendingTrend_increased,
    };
  }

  static String _averageDailyKey(String? variant) {
    return variant == 'no_spending'
        ? LocaleKeys.dashboard_insights_cards_averageDaily_no_spending
        : LocaleKeys.dashboard_insights_cards_averageDaily_current;
  }

  static String _smartRecommendationKey(String? variant) {
    return switch (variant) {
      'higher' => LocaleKeys.dashboard_insights_cards_smartRecommendation_higher,
      'lower' => LocaleKeys.dashboard_insights_cards_smartRecommendation_lower,
      _ => LocaleKeys.dashboard_insights_cards_smartRecommendation_on_track,
    };
  }
}
