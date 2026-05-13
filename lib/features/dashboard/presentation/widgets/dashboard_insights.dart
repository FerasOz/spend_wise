import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';

import '../../domain/entities/dashboard_insight.dart';
import 'dashboard_section_card.dart';
import 'dashboard_section_empty_state.dart';

class DashboardInsights extends StatelessWidget {
  const DashboardInsights({required this.insights, super.key});

  final List<DashboardInsight> insights;

  @override
  Widget build(BuildContext context) {
    return DashboardSectionCard(
      title: 'Insights',
      subtitle: 'Quick patterns from your latest activity',
      child: insights.isEmpty
          ? const DashboardSectionEmptyState(
              title: 'No insights yet',
              message:
                  'Add a few more expenses to unlock smarter spending observations.',
            )
          : Column(
              children: [
                for (var index = 0; index < insights.length; index++) ...[
                  _InsightTile(insight: insights[index]),
                  if (index != insights.length - 1)
                    SizedBox(height: AppSpacing.md.h),
                ],
              ],
            ),
    );
  }
}

class _InsightTile extends StatelessWidget {
  const _InsightTile({required this.insight});

  final DashboardInsight insight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha(14),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.auto_graph_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: AppSpacing.xs.h),
                Text(insight.message),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
