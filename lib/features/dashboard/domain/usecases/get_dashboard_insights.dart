import 'package:spend_wise/features/dashboard/domain/entities/dashboard_insight.dart';
import 'package:spend_wise/features/dashboard/domain/entities/dashboard_source_data.dart';
import 'package:spend_wise/features/dashboard/domain/usecases/get_top_categories.dart';

class GetDashboardInsights {
  const GetDashboardInsights(this._getTopCategories);

  final GetTopCategories _getTopCategories;

  List<DashboardInsight> call(DashboardSourceData sourceData) {
    final insights = <DashboardInsight>[];
    final now = DateTime.now();
    final currentWeekStart = _startOfDay(
      now.subtract(Duration(days: now.weekday - 1)),
    );
    final previousWeekStart = currentWeekStart.subtract(const Duration(days: 7));
    final previousWeekEnd = currentWeekStart.subtract(const Duration(days: 1));

    final currentWeekSpending = sourceData.expenses
        .where((expense) => !expense.date.isBefore(currentWeekStart))
        .fold<double>(0, (sum, expense) => sum + expense.amount);
    final previousWeekSpending = sourceData.expenses
        .where(
          (expense) =>
              !expense.date.isBefore(previousWeekStart) &&
              !expense.date.isAfter(previousWeekEnd),
        )
        .fold<double>(0, (sum, expense) => sum + expense.amount);

    if (previousWeekSpending > 0) {
      final delta = ((currentWeekSpending - previousWeekSpending) /
              previousWeekSpending) *
          100;
      final direction = delta >= 0 ? 'more' : 'less';
      insights.add(
        DashboardInsight(
          title: 'Weekly trend',
          message:
              'You spent ${delta.abs().round()}% $direction than last week.',
        ),
      );
    }

    final topCategory = _getTopCategories(sourceData, limit: 1);
    if (topCategory.isNotEmpty) {
      insights.add(
        DashboardInsight(
          title: 'Top category',
          message:
              '${topCategory.first.category.name} leads your spending at ${(topCategory.first.percentage * 100).round()}%.',
        ),
      );
    }

    if (sourceData.expenses.isNotEmpty) {
      final monthSpending = sourceData.expenses
          .where(
            (expense) =>
                expense.date.year == now.year &&
                expense.date.month == now.month,
          )
          .fold<double>(0, (sum, expense) => sum + expense.amount);

      insights.add(
        DashboardInsight(
          title: 'This month',
          message:
              'You have logged ${sourceData.expenses.length} expenses and spent \$${monthSpending.toStringAsFixed(2)} this month.',
        ),
      );
    }

    return insights.take(3).toList(growable: false);
  }

  DateTime _startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
