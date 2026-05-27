import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/currency_text.dart';
import '../../domain/entities/spending_chart_point.dart';
import 'dashboard_section_card.dart';
import 'dashboard_section_empty_state.dart';
import 'dashboard_spending_chart_body.dart';

class DashboardSpendingChart extends StatelessWidget {
  const DashboardSpendingChart({required this.points, super.key});

  final List<SpendingChartPoint> points;

  @override
  Widget build(BuildContext context) {
    final total = points.fold<double>(0, (sum, point) => sum + point.total);
    final highest = points.isEmpty
        ? const SpendingChartPoint(label: 'Mon', total: 0)
        : points.reduce((a, b) => a.total >= b.total ? a : b);

    return DashboardSectionCard(
      title: LocaleKeys.dashboard_chart_section_weeklySpending.tr(),
      subtitle: LocaleKeys.dashboard_chart_section_weeklySubtitle.tr(),
      child: total == 0
          ? DashboardSectionEmptyState(
              title: LocaleKeys.dashboard_chart_section_noData_title.tr(),
              message: LocaleKeys.dashboard_chart_section_noData_message.tr(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.sm.w,
                  runSpacing: AppSpacing.sm.h,
                  children: [
                    _ChartChip(
                      label: LocaleKeys.dashboard_chart_total.tr(),
                      child: CurrencyText(amount: total),
                    ),
                    _ChartChip(
                      label: LocaleKeys.dashboard_chart_highestDay.tr(),
                      child: CurrencyText(
                        amount: highest.total,
                        suffix:
                            ' ${LocaleKeys.dashboard_chart_on.tr()} ${highest.label}',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.lg.h),
                SizedBox(
                  height: 220.h,
                  child: DashboardSpendingChartBody(points: points),
                ),
              ],
            ),
    );
  }
}

class _ChartChip extends StatelessWidget {
  const _ChartChip({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Text('$label: '), child],
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }
}
