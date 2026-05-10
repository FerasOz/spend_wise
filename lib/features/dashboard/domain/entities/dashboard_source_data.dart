import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense.dart';

class DashboardSourceData {
  const DashboardSourceData({
    required this.expenses,
    required this.categories,
  });

  final List<Expense> expenses;
  final List<Category> categories;
}
