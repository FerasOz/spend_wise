import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/spending_chart_point.dart';
import 'dashboard_section_card.dart';

class DashboardSpendingChart extends StatelessWidget {
  const DashboardSpendingChart({required this.points, super.key});

  final List<SpendingChartPoint> points;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxY = points.fold<double>(
      0,
      (max, point) => point.total > max ? point.total : max,
    );
    final totalSpending = points.fold<double>(0, (sum, point) => sum + point.total);
    final peakPoint = points.isEmpty
        ? null
        : points.reduce((current, next) => current.total >= next.total ? current : next);
    final safeMaxY = maxY == 0 ? 100.0 : maxY * 1.25;
    final yInterval = safeMaxY / 4;

    return DashboardSectionCard(
      title: 'Weekly spending',
      subtitle: 'Your last 7 days of expense activity',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12.w,
            runSpacing: 6.h,
            children: [
              _ChartContextChip(
                label: 'Total',
                value: '\$${totalSpending.toStringAsFixed(2)}',
              ),
              _ChartContextChip(
                label: 'Highest day',
                value: peakPoint == null
                    ? 'N/A'
                    : '${peakPoint.label} • \$${peakPoint.total.toStringAsFixed(2)}',
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (totalSpending == 0)
            _ChartEmptyState(theme: theme)
          else
            SizedBox(
              height: 220.h,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: safeMaxY,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: yInterval,
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 46.w,
                        interval: yInterval,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '\$${value.toStringAsFixed(0)}',
                            style: theme.textTheme.labelSmall,
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        reservedSize: 34,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= points.length) {
                            return const SizedBox.shrink();
                          }

                          return Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: Text(points[index].label),
                          );
                        },
                      ),
                    ),
                  ),
                  lineTouchData: LineTouchData(
                    enabled: true,
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      fitInsideHorizontally: true,
                      fitInsideVertically: true,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final point = points[spot.x.toInt()];
                          return LineTooltipItem(
                            '${point.label}\n\$${point.total.toStringAsFixed(2)}',
                            TextStyle(
                              color: theme.colorScheme.onInverseSurface,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.sp,
                            ),
                          );
                        }).toList(growable: false);
                      },
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      curveSmoothness: 0.18,
                      preventCurveOverShooting: true,
                      color: theme.colorScheme.primary,
                      barWidth: 4,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                          radius: 3.8,
                          color: theme.colorScheme.primary,
                          strokeWidth: 2,
                          strokeColor: theme.colorScheme.surface,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: theme.colorScheme.primary.withAlpha(28),
                      ),
                      spots: List<FlSpot>.generate(
                        points.length,
                        (index) => FlSpot(index.toDouble(), points[index].total),
                        growable: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ChartContextChip extends StatelessWidget {
  const _ChartContextChip({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha(16),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodySmall,
          children: [
            TextSpan(text: '$label: '),
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartEmptyState extends StatelessWidget {
  const _ChartEmptyState({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220.h,
      child: Center(
        child: Text(
          'No weekly spending data yet.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
