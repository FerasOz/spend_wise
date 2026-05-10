import 'package:spend_wise/features/dashboard/domain/entities/dashboard_source_data.dart';
import 'package:spend_wise/features/dashboard/domain/entities/spending_chart_point.dart';

class GetWeeklySpending {
  const GetWeeklySpending();

  List<SpendingChartPoint> call(DashboardSourceData sourceData) {
    final now = DateTime.now();
    final weekStart = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));
    final totals = List<double>.filled(7, 0);
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    for (final expense in sourceData.expenses) {
      final expenseDay = DateTime(
        expense.date.year,
        expense.date.month,
        expense.date.day,
      );
      final diff = expenseDay.difference(weekStart).inDays;
      if (diff >= 0 && diff < 7) {
        totals[diff] += expense.amount;
      }
    }

    return List<SpendingChartPoint>.generate(
      7,
      (index) => SpendingChartPoint(label: labels[index], total: totals[index]),
      growable: false,
    );
  }
}
