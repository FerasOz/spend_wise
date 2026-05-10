import 'package:spend_wise/features/dashboard/domain/entities/dashboard_source_data.dart';
import 'package:spend_wise/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:spend_wise/features/dashboard/domain/usecases/get_top_categories.dart';

class GetDashboardSummary {
  const GetDashboardSummary(this._getTopCategories);

  final GetTopCategories _getTopCategories;

  DashboardSummary call(DashboardSourceData sourceData) {
    final now = DateTime.now();
    final totalSpending = sourceData.expenses.fold<double>(
      0,
      (sum, expense) => sum + expense.amount,
    );
    final monthlySpending = sourceData.expenses
        .where((expense) => expense.date.year == now.year && expense.date.month == now.month)
        .fold<double>(0, (sum, expense) => sum + expense.amount);
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weeklySpending = sourceData.expenses
        .where((expense) => !expense.date.isBefore(_startOfDay(weekStart)))
        .fold<double>(0, (sum, expense) => sum + expense.amount);
    final trackedDays = sourceData.expenses
        .map((expense) => _startOfDay(expense.date))
        .toSet()
        .length;
    final averageDailySpending = trackedDays == 0
        ? 0.0
        : totalSpending / trackedDays;
    final topCategories = _getTopCategories(sourceData, limit: 1);
    final topCategory = topCategories.isEmpty ? null : topCategories.first;

    return DashboardSummary(
      totalSpending: totalSpending,
      monthlySpending: monthlySpending,
      weeklySpending: weeklySpending,
      averageDailySpending: averageDailySpending,
      transactionCount: sourceData.expenses.length,
      topCategory: topCategory,
    );
  }

  DateTime _startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
