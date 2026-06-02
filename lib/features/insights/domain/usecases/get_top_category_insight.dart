import '../../../categories/domain/entities/category.dart';
import '../../../expenses/domain/entities/expense.dart';
import '../entities/insight_color_tokens.dart';
import '../entities/insight_card.dart';

class GetTopCategoryInsight {
  InsightCard call(
    List<Expense> expenses,
    Map<String, Category> categoriesMap,
  ) {
    if (expenses.isEmpty) {
      return _emptyInsight();
    }

    final totals = <String, double>{};
    for (final expense in expenses) {
      totals[expense.categoryId] = (totals[expense.categoryId] ?? 0) + expense.amount;
    }

    final topId = totals.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    final amount = totals[topId]!;
    final total = expenses.fold<double>(0, (sum, expense) => sum + expense.amount);
    final percentage = (amount / total * 100).toStringAsFixed(1);
    final category = categoriesMap[topId];

    return InsightCard(
      id: 'top_category',
      title: 'Top category',
      message: 'top_category.message',
      type: InsightType.topCategory,
      color: category?.color ?? InsightColorTokens.blue,
      amount: amount,
      metadata: {
        'category': category?.name ?? 'Unknown',
        'categoryId': category?.id ?? '',
        'percentage': percentage,
      },
    );
  }

  InsightCard _emptyInsight() => InsightCard(
    id: 'top_category',
    title: 'Top category',
    message: '',
    type: InsightType.topCategory,
    color: InsightColorTokens.blue,
  );
}
