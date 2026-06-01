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

    final key = switch (insight.type) {
      InsightType.spending_trend => _spendingTrendKey(args['variant']),
      InsightType.average_daily => _averageDailyKey(args['variant']),
      InsightType.smart_recommendation => _smartRecommendationKey(args['variant']),
      _ => _messageKey(insight.type),
    };

    final message = key.tr(namedArgs: args);
    final category = args['category'];
    if (insight.type == InsightType.smart_recommendation && category != null) {
      final reduceCategory =
          LocaleKeys.dashboard_insights_cards_smartRecommendation_reduceCategory
              .tr(namedArgs: {'category': category});
      return '$message\n$reduceCategory';
    }
    return message;
  }

  static String value(InsightCard insight) {
    if (insight.type == InsightType.spending_streak) {
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

  static String _titleKey(InsightType type) {
    return switch (type) {
      InsightType.topCategory => LocaleKeys.dashboard_insights_cards_topCategory_title,
      InsightType.spending_trend => LocaleKeys.dashboard_insights_cards_spendingTrend_title,
      InsightType.average_daily => LocaleKeys.dashboard_insights_cards_averageDaily_title,
      InsightType.highest_spending_day =>
        LocaleKeys.dashboard_insights_cards_highestSpendingDay_title,
      InsightType.spending_streak => LocaleKeys.dashboard_insights_cards_spendingStreak_title,
      InsightType.smart_recommendation =>
        LocaleKeys.dashboard_insights_cards_smartRecommendation_title,
    };
  }

  static String _messageKey(InsightType type) {
    return switch (type) {
      InsightType.topCategory => LocaleKeys.dashboard_insights_cards_topCategory_message,
      InsightType.highest_spending_day =>
        LocaleKeys.dashboard_insights_cards_highestSpendingDay_message,
      InsightType.spending_streak => LocaleKeys.dashboard_insights_cards_spendingStreak_message,
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
