import 'package:spend_wise/features/dashboard/domain/entities/dashboard_source_data.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense.dart';

class GetRecentExpenses {
  const GetRecentExpenses();

  List<Expense> call(
    DashboardSourceData sourceData, {
    int limit = 5,
  }) {
    final expenses = [...sourceData.expenses]
      ..sort((first, second) => second.date.compareTo(first.date));

    return expenses.take(limit).toList(growable: false);
  }
}
