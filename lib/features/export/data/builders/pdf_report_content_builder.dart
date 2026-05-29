import 'package:spend_wise/core/services/currency_display_service.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense.dart';
import 'package:spend_wise/features/settings/domain/entities/app_currency.dart';

class PdfReportContent {
  const PdfReportContent({
    required this.totalSpending,
    required this.topCategory,
    required this.recentExpenses,
    required this.weeklySummary,
  });

  final String totalSpending;
  final String topCategory;
  final List<String> recentExpenses;
  final List<String> weeklySummary;
}

class PdfReportContentBuilder {
  const PdfReportContentBuilder();

  PdfReportContent build({
    required List<Expense> expenses,
    required List<Category> categories,
    required AppCurrency currency,
    required String topCategoryName,
    required double totalSpendingUsd,
    required List<(String label, double totalUsd)> weekly,
  }) {
    final total = CurrencyDisplayService.formatFromUsd(totalSpendingUsd, currency);
    final categoryById = {for (final c in categories) c.id: c};

    final recent = [...expenses]..sort((a, b) => b.date.compareTo(a.date));
    final recentLines = recent.take(5).map((e) {
      final amount = CurrencyDisplayService.formatFromUsd(e.amount, currency);
      final categoryName = categoryById[e.categoryId]?.name ?? 'Unknown';
      return '$amount - ${e.title} - $categoryName';
    }).toList(growable: false);

    final weeklyLines = weekly.map((p) {
      final amount = CurrencyDisplayService.formatFromUsd(p.$2, currency);
      return '${p.$1}: $amount';
    }).toList(growable: false);

    return PdfReportContent(
      totalSpending: total,
      topCategory: topCategoryName,
      recentExpenses: recentLines,
      weeklySummary: weeklyLines,
    );
  }
}

