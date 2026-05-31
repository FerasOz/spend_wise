import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

import '../../../../core/widgets/currency_text.dart';
import '../../domain/entities/insight_card.dart';

class InsightCardWidget extends StatelessWidget {
  const InsightCardWidget({required this.insight, super.key});

  final InsightCard insight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      color: theme.colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _InsightIcon(type: insight.type),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _title(context),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (insight.amount != null)
                        CurrencyText(
                          amount: insight.amount!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        )
                      else if (insight.value != null)
                        Text(
                          _value(context),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              _message(context),
              style: theme.textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _title(BuildContext context) {
    return _titleKey.tr();
  }

  String _message(BuildContext context) {
    final args = Map<String, String>.from(insight.metadata);
    final day = _localizedDay(context);
    if (day != null) args['day'] = day;

    final key = switch (insight.type) {
      InsightType.spending_trend => _spendingTrendMessageKey(args['variant']),
      InsightType.average_daily => _averageDailyMessageKey(args['variant']),
      InsightType.smart_recommendation =>
        _smartRecommendationMessageKey(args['variant']),
      _ => _messageKey,
    };

    final message = key.tr(namedArgs: args);
    final category = args['category'];
    if (insight.type == InsightType.smart_recommendation && category != null) {
      return '$message\n${LocaleKeys.dashboard_insights_cards_smartRecommendation_reduceCategory.tr(namedArgs: {'category': category})}';
    }
    return message;
  }

  String _value(BuildContext context) {
    if (insight.type == InsightType.spending_streak) {
      return LocaleKeys.dashboard_insights_cards_spendingStreak_value.tr(
        namedArgs: {'days': insight.metadata['days'] ?? insight.value ?? '0'},
      );
    }
    return insight.value ?? '';
  }

  String? _localizedDay(BuildContext context) {
    final rawDay = insight.metadata['day'];
    final date = rawDay == null ? null : DateTime.tryParse(rawDay);
    if (date == null) return null;
    return MaterialLocalizations.of(context).formatShortDate(date);
  }

  String get _titleKey {
    return switch (insight.type) {
      InsightType.topCategory =>
        LocaleKeys.dashboard_insights_cards_topCategory_title,
      InsightType.spending_trend =>
        LocaleKeys.dashboard_insights_cards_spendingTrend_title,
      InsightType.average_daily =>
        LocaleKeys.dashboard_insights_cards_averageDaily_title,
      InsightType.highest_spending_day =>
        LocaleKeys.dashboard_insights_cards_highestSpendingDay_title,
      InsightType.spending_streak =>
        LocaleKeys.dashboard_insights_cards_spendingStreak_title,
      InsightType.smart_recommendation =>
        LocaleKeys.dashboard_insights_cards_smartRecommendation_title,
    };
  }

  String get _messageKey {
    return switch (insight.type) {
      InsightType.topCategory =>
        LocaleKeys.dashboard_insights_cards_topCategory_message,
      InsightType.highest_spending_day =>
        LocaleKeys.dashboard_insights_cards_highestSpendingDay_message,
      InsightType.spending_streak =>
        LocaleKeys.dashboard_insights_cards_spendingStreak_message,
      _ => '',
    };
  }

  String _spendingTrendMessageKey(String? variant) {
    return switch (variant) {
      'started' => LocaleKeys.dashboard_insights_cards_spendingTrend_started,
      'decreased' =>
        LocaleKeys.dashboard_insights_cards_spendingTrend_decreased,
      _ => LocaleKeys.dashboard_insights_cards_spendingTrend_increased,
    };
  }

  String _averageDailyMessageKey(String? variant) {
    return variant == 'no_spending'
        ? LocaleKeys.dashboard_insights_cards_averageDaily_no_spending
        : LocaleKeys.dashboard_insights_cards_averageDaily_current;
  }

  String _smartRecommendationMessageKey(String? variant) {
    return switch (variant) {
      'higher' => LocaleKeys.dashboard_insights_cards_smartRecommendation_higher,
      'lower' => LocaleKeys.dashboard_insights_cards_smartRecommendation_lower,
      _ => LocaleKeys.dashboard_insights_cards_smartRecommendation_on_track,
    };
  }
}

class _InsightIcon extends StatelessWidget {
  const _InsightIcon({required this.type});

  final InsightType type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Icon(
        _iconData,
        color: theme.colorScheme.onPrimaryContainer,
        size: 22.sp,
      ),
    );
  }

  IconData get _iconData {
    return switch (type) {
      InsightType.topCategory => Icons.category_outlined,
      InsightType.spending_trend => Icons.trending_up_outlined,
      InsightType.average_daily => Icons.calendar_today_outlined,
      InsightType.highest_spending_day => Icons.local_fire_department_outlined,
      InsightType.spending_streak => Icons.timeline_outlined,
      InsightType.smart_recommendation => Icons.lightbulb_outline,
    };
  }
}
