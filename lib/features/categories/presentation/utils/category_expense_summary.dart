import 'package:spend_wise/features/expenses/domain/entities/expense.dart';

class CategoryExpenseSummary {
  const CategoryExpenseSummary({
    required this.expenseCount,
    required this.totalSpent,
  });

  final int expenseCount;
  final double totalSpent;

  static const empty = CategoryExpenseSummary(expenseCount: 0, totalSpent: 0);

  static Map<String, CategoryExpenseSummary> buildByCategoryId(
    List<Expense> expenses,
  ) {
    final summaries = <String, CategoryExpenseSummary>{};

    for (final expense in expenses) {
      final current = summaries[expense.categoryId] ?? empty;
      summaries[expense.categoryId] = CategoryExpenseSummary(
        expenseCount: current.expenseCount + 1,
        totalSpent: current.totalSpent + expense.amount,
      );
    }

    return summaries;
  }
}
