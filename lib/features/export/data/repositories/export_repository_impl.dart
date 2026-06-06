import 'dart:io';

import 'package:share_plus/share_plus.dart';

import '../../../categories/data/datasources/category_local_data_source.dart';
import '../../../categories/data/models/category_model.dart';
import '../../../categories/domain/repositories/category_repository.dart';
import '../../../../core/services/app_clock.dart';
import '../../../budgets/data/datasources/budget_local_data_source.dart';
import '../../../budgets/data/models/budget_model.dart';
import '../../../budgets/domain/repositories/budget_repository.dart';
import '../../../dashboard/domain/entities/dashboard_source_data.dart';
import '../../../dashboard/domain/usecases/get_dashboard_summary.dart';
import '../../../dashboard/domain/usecases/get_top_categories.dart';
import '../../../dashboard/domain/usecases/get_weekly_spending.dart';
import '../../../expenses/data/datasources/expense_local_data_source.dart';
import '../../../expenses/data/models/expense_model.dart';
import '../../../expenses/domain/repositories/expense_repository.dart';
import '../../../recurring/data/datasources/recurring_expense_local_data_source.dart';
import '../../../recurring/data/models/recurring_expense_model.dart';
import '../../../recurring/domain/repositories/recurring_expense_repository.dart';
import '../../../settings/data/datasources/settings_local_data_source.dart';
import '../../../settings/domain/repositories/settings_repository.dart';
import '../../domain/entities/export_file.dart';
import '../../domain/entities/export_history_item.dart';
import '../../domain/entities/export_type.dart';
import '../../domain/repositories/export_repository.dart';
import '../builders/backup_payload_builder.dart';
import '../builders/expenses_export_payload_builder.dart';
import '../builders/pdf_report_content_builder.dart';
import '../datasources/export_file_local_data_source.dart';
import '../../domain/entities/export_file_result.dart';
import '../datasources/export_history_local_data_source.dart';
import '../datasources/export_pdf_builder.dart';
import '../models/export_history_item_model.dart';
import '../utils/export_file_name_builder.dart';

part 'export_repository_impl_backup.dart';
part 'export_repository_impl_history.dart';
part 'export_repository_impl_pdf.dart';

class ExportRepositoryImpl implements ExportRepository {
  const ExportRepositoryImpl({
    required ExpenseRepository expenseRepository,
    required CategoryRepository categoryRepository,
    required BudgetRepository budgetRepository,
    required RecurringExpenseRepository recurringRepository,
    required SettingsRepository settingsRepository,
    required ExportFileLocalDataSource files,
    required ExportHistoryLocalDataSource history,
    required ExportPdfBuilder pdfBuilder,
    required GetDashboardSummary getDashboardSummary,
    required GetTopCategories getTopCategories,
    required GetWeeklySpending getWeeklySpending,
    required ExpensesExportPayloadBuilder expensesPayload,
    required BackupPayloadBuilder backupPayload,
    required PdfReportContentBuilder pdfContent,
    required AppClock clock,
  }) : _expenses = expenseRepository,
       _categories = categoryRepository,
       _budgets = budgetRepository,
       _recurring = recurringRepository,
       _settings = settingsRepository,
       _files = files,
       _history = history,
       _pdfBuilder = pdfBuilder,
       _getDashboardSummary = getDashboardSummary,
       _getTopCategories = getTopCategories,
       _getWeeklySpending = getWeeklySpending,
       _expensesPayload = expensesPayload,
       _backupPayload = backupPayload,
       _pdfContent = pdfContent,
       _clock = clock;

  final ExpenseRepository _expenses;
  final CategoryRepository _categories;
  final BudgetRepository _budgets;
  final RecurringExpenseRepository _recurring;
  final SettingsRepository _settings;
  final ExportFileLocalDataSource _files;
  final ExportHistoryLocalDataSource _history;
  final ExportPdfBuilder _pdfBuilder;
  final GetDashboardSummary _getDashboardSummary;
  final GetTopCategories _getTopCategories;
  final GetWeeklySpending _getWeeklySpending;
  final ExpensesExportPayloadBuilder _expensesPayload;
  final BackupPayloadBuilder _backupPayload;
  final PdfReportContentBuilder _pdfContent;
  final AppClock _clock;

  @override
  Future<ExportFile> exportExpenses(ExportType type) async {
    final expenses = await _expenses.getExpenses();
    final categories = await _categories.getCategories();
    final byId = {for (final c in categories) c.id: c};
    final base = ExportFileNameBuilder.build(type, _clock);

    final result = switch (type) {
      ExportType.csv => await _files.writeCsv(
        fileNameBase: base,
        rows: _expensesPayload.csvRows(expenses, byId),
        clock: _clock,
      ),
      ExportType.json => await _files.writeJson(
        fileNameBase: base,
        json: _expensesPayload.jsonPayload(expenses, byId, _clock),
        type: type,
        clock: _clock,
      ),
      _ => throw UnsupportedError('Unsupported export type: ${type.key}'),
    };

    return _toExportFile(await _storeHistory(result));
  }

  @override
  Future<ExportFile> exportPdfReport() => _exportPdfReport();

  @override
  Future<ExportFile> exportAllData() => _exportAllData();

  @override
  Future<void> shareFile(String path) async {
    final file = File(path);
    if (!await file.exists()) return;
    await SharePlus.instance.share(ShareParams(files: [XFile(path)]));
  }

  @override
  Future<void> saveFileToDownloads(String path) => _files.copyToDownloads(path);

  @override
  Future<List<ExportHistoryItem>> getHistory() async {
    final items = await _history.getHistory();
    return items.map((m) => m.toEntity()).toList(growable: false);
  }

  @override
  Future<void> deleteHistoryItem(String id) => _history.delete(id);
}
