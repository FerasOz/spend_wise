import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/insight_card.dart';

class InsightIcon extends StatelessWidget {
  const InsightIcon({required this.type, super.key});

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
      InsightType.spendingTrend => Icons.trending_up_outlined,
      InsightType.averageDaily => Icons.calendar_today_outlined,
      InsightType.highestSpendingDay => Icons.local_fire_department_outlined,
      InsightType.spendingStreak => Icons.timeline_outlined,
      InsightType.smartRecommendation => Icons.lightbulb_outline,
    };
  }
}
