import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/currencies.dart';
import '../../../../core/services/currency_display_service.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/spending_chart_point.dart';

class DashboardSpendingChartBody extends StatelessWidget {
  const DashboardSpendingChartBody({required this.points, super.key});

  final List<SpendingChartPoint> points;

  @override
  Widget build(BuildContext context) {
    final currency = context.select(
      (SettingsCubit cubit) =>
          cubit.state.settings?.currency ?? currencyByCode('USD'),
    );
    final maxY = points.fold<double>(
      0,
      (max, point) => point.total > max ? point.total : max,
    );
    final safeMaxY = maxY == 0 ? 100.0 : maxY * 1.25;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: safeMaxY,
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: safeMaxY / 4,
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 52.w,
                interval: safeMaxY / 4,
                getTitlesWidget: (value, _) => Text(
                  CurrencyDisplayService.formatFromUsd(value, currency),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, _) => Text(
                  value >= 0 && value < points.length
                      ? points[value.toInt()].label
                      : '',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) => spots.map((spot) {
                final index = spot.x.toInt().clamp(0, points.length - 1);
                final label = points[index].label;
                final amount = CurrencyDisplayService.formatFromUsd(
                  spot.y,
                  currency,
                );
                return LineTooltipItem(
                  '$label\n$amount',
                  Theme.of(context).textTheme.labelMedium!,
                );
              }).toList(),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              curveSmoothness: 0.18,
              preventCurveOverShooting: true,
              barWidth: 3,
              color: Theme.of(context).colorScheme.primary,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Theme.of(context).colorScheme.primary.withAlpha(28),
              ),
              spots: List.generate(
                points.length,
                (index) => FlSpot(index.toDouble(), points[index].total),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
