import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';
import 'package:spend_wise/features/insights/domain/entities/insight_card.dart';
import 'package:spend_wise/features/insights/presentation/widgets/insight_card_widget.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';
import 'dashboard_section_card.dart';
import 'dashboard_section_empty_state.dart';

class DashboardInsights extends StatelessWidget {
  const DashboardInsights({required this.insights, super.key});

  final List<InsightCard> insights;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: AlwaysStoppedAnimation(0.95),
      child: DashboardSectionCard(
        title: LocaleKeys.dashboard_insights_title.tr(),
        subtitle: LocaleKeys.dashboard_insights_subTitle.tr(),
        child: insights.isEmpty
            ? DashboardSectionEmptyState(
                title: LocaleKeys.dashboard_insights_emptyTitle.tr(),
                message: LocaleKeys.dashboard_insights_emptyDescription.tr(),
              )
            : FadeTransition(
                opacity: AlwaysStoppedAnimation(0.9),
                child: Column(
                  children: [
                    for (var index = 0; index < insights.length; index++) ...[
                      InsightCardWidget(insight: insights[index]),
                      if (index != insights.length - 1)
                        SizedBox(height: AppSpacing.md.h),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}
