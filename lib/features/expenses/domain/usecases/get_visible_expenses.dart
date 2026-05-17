import '../entities/expense.dart';
import '../entities/expense_filter.dart';

class GetVisibleExpenses {
  const GetVisibleExpenses();

  List<Expense> call({
    required List<Expense> expenses,
    required ExpenseFilter filter,
  }) {
    final loweredQuery = filter.searchQuery.trim().toLowerCase();

    return expenses
        .where((expense) {
          final matchesQuery =
              loweredQuery.isEmpty ||
              expense.title.toLowerCase().contains(loweredQuery);
          final matchesCategory =
              filter.categoryId == null || expense.categoryId == filter.categoryId;
          final matchesStartDate =
              filter.startDate == null || !expense.date.isBefore(filter.startDate!);
          final matchesEndDate =
              filter.endDate == null || !expense.date.isAfter(filter.endDate!);

          return matchesQuery &&
              matchesCategory &&
              matchesStartDate &&
              matchesEndDate;
        })
        .toList(growable: false)
      ..sort((first, second) {
        switch (filter.sortOption) {
          case ExpenseSortOption.newest:
            return second.date.compareTo(first.date);
          case ExpenseSortOption.oldest:
            return first.date.compareTo(second.date);
          case ExpenseSortOption.highestAmount:
            return second.amount.compareTo(first.amount);
          case ExpenseSortOption.lowestAmount:
            return first.amount.compareTo(second.amount);
        }
      });
  }
}
