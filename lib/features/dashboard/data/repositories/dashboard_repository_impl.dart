import 'package:spend_wise/features/categories/domain/repositories/category_repository.dart';
import 'package:spend_wise/features/dashboard/domain/entities/dashboard_source_data.dart';
import 'package:spend_wise/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:spend_wise/features/expenses/domain/repositories/expense_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl({
    required ExpenseRepository expenseRepository,
    required CategoryRepository categoryRepository,
  }) : _expenseRepository = expenseRepository,
       _categoryRepository = categoryRepository;

  final ExpenseRepository _expenseRepository;
  final CategoryRepository _categoryRepository;

  @override
  Future<DashboardSourceData> getDashboardSourceData() async {
    final expensesFuture = _expenseRepository.getExpenses();
    final categoriesFuture = _categoryRepository.getCategories();
    final expenses = await expensesFuture;
    final categories = await categoriesFuture;

    return DashboardSourceData(expenses: expenses, categories: categories);
  }
}
