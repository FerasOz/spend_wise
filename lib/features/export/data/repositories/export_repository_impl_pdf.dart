part of 'export_repository_impl.dart';

extension _ExportRepositoryPdfX on ExportRepositoryImpl {
  Future<ExportFile> _exportPdfReport() async {
    final expenses = await _expenses.getExpenses();
    final categories = await _categories.getCategories();
    final settings = await _settings.getSettings();
    final source = DashboardSourceData(expenses: expenses, categories: categories);
    final summary = _getDashboardSummary(source);
    final top = _getTopCategories(source, limit: 1);
    final topName = top.isEmpty ? '—' : top.first.category.name;
    final weekly = _getWeeklySpending(source).map((p) => (p.label, p.total)).toList();

    final content = _pdfContent.build(
      expenses: expenses,
      categories: categories,
      currency: settings.currency,
      topCategoryName: topName,
      totalSpendingUsd: summary.totalSpending,
      weekly: weekly,
    );

    final bytes = _pdfBuilder.buildSimpleReport(
      appName: 'SpendWise',
      generatedAt: _clock.now().toString(),
      totalSpending: content.totalSpending,
      topCategory: content.topCategory,
      recentExpenses: content.recentExpenses,
      weeklySummary: content.weeklySummary,
    );

    final result = await _files.writePdf(
      fileNameBase: ExportFileNameBuilder.build(ExportType.pdf, _clock),
      bytes: await bytes,
      clock: _clock,
    );
    return _toExportFile(await _storeHistory(result));
  }
}

