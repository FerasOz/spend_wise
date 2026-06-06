import '../../../categories/domain/entities/category.dart';
import '../../../expenses/data/models/expense_model.dart';
import '../../../expenses/domain/entities/expense.dart';
import 'package:spend_wise/core/services/app_clock.dart';

class ExpensesExportPayloadBuilder {
  const ExpensesExportPayloadBuilder();

  List<List<dynamic>> csvRows(
    List<Expense> expenses,
    Map<String, Category> categoriesById,
  ) {
    final rows = <List<dynamic>>[
      ['Title', 'Amount(USD)', 'Category', 'Date', 'Note'],
    ];
    for (final e in expenses) {
      final category = categoriesById[e.categoryId]?.name ?? 'Unknown';
      rows.add([e.title, e.amount, category, e.date.toIso8601String(), e.note ?? '']);
    }
    return rows;
  }

  Object jsonPayload(
    List<Expense> expenses,
    Map<String, Category> categoriesById,
    AppClock clock,
  ) {
    return {
      'generatedAt': clock.now().toIso8601String(),
      'expenses': expenses.map((e) {
        final category = categoriesById[e.categoryId]?.name ?? 'Unknown';
        return {...ExpenseModel.fromEntity(e).toJson(), 'categoryName': category};
      }).toList(growable: false),
    };
  }
}

