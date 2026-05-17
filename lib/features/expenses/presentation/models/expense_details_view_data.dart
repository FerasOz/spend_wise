import '../../../../features/categories/domain/entities/category.dart';
import '../../domain/entities/expense.dart';

class ExpenseDetailsViewData {
  const ExpenseDetailsViewData({
    required this.expense,
    required this.category,
  });

  final Expense expense;
  final Category category;

  bool get hasNote => (expense.note ?? '').trim().isNotEmpty;
}
