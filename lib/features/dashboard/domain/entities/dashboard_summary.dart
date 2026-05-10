import 'package:spend_wise/features/dashboard/domain/entities/category_spending.dart';

class DashboardSummary {
  const DashboardSummary({
    required this.totalSpending,
    required this.monthlySpending,
    required this.weeklySpending,
    required this.averageDailySpending,
    required this.transactionCount,
    this.topCategory,
  });

  final double totalSpending;
  final double monthlySpending;
  final double weeklySpending;
  final double averageDailySpending;
  final int transactionCount;
  final CategorySpending? topCategory;
}
