import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';

import 'package:spend_wise/features/insights/domain/entities/insight_card.dart';
import 'package:spend_wise/features/insights/presentation/widgets/insight_card_widget.dart';
import 'dashboard_section_card.dart';
import 'dashboard_section_empty_state.dart';

class DashboardInsights extends StatelessWidget {
  const DashboardInsights({required this.insights, super.key});

  final List<InsightCard> insights;

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
                  InsightCardWidget(insight: insights[index]),
                  if (index != insights.length - 1)
                    SizedBox(height: AppSpacing.md.h),
                ],
              ],
            ),
    );
  }
}
