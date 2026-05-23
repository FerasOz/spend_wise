import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      title: 'Weekly spending',
      subtitle: 'Your spending pace across this week',
      child: total == 0
          ? const DashboardSectionEmptyState(
              title: 'No weekly data',
              message: 'Your weekly spending chart will appear once this week has activity.',
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.sm.w,
                  runSpacing: AppSpacing.sm.h,
                  children: [
                    _ChartChip(label: 'Total', child: CurrencyText(amount: total)),
                    _ChartChip(
                      label: 'Highest day',
                      child: CurrencyText(amount: highest.total, suffix: ' on ${highest.label}'),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.lg.h),
                SizedBox(height: 220.h, child: DashboardSpendingChartBody(points: points)),
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
      label: Row(mainAxisSize: MainAxisSize.min, children: [Text('$label: '), child]),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }
}
