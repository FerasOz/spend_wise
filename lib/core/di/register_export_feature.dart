import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/export/data/builders/backup_payload_builder.dart';
import '../../features/export/data/builders/expenses_export_payload_builder.dart';
import '../../features/export/data/builders/pdf_report_content_builder.dart';
import '../../features/export/data/datasources/export_file_local_data_source.dart';
import '../../features/export/data/datasources/export_history_local_data_source.dart';
import '../../features/export/data/datasources/export_pdf_builder.dart';
import '../../features/export/data/repositories/export_repository_impl.dart';
import '../../features/export/domain/repositories/export_repository.dart';
import '../../features/export/domain/usecases/delete_export_history.dart';
import '../../features/export/domain/usecases/export_all_data.dart';
import '../../features/export/domain/usecases/export_expenses_as_csv.dart';
import '../../features/export/domain/usecases/export_expenses_as_json.dart';
import '../../features/export/domain/usecases/export_expenses_as_pdf.dart';
import '../../features/export/domain/usecases/get_export_history.dart';
import '../../features/export/domain/usecases/save_export_file.dart';
import '../../features/export/domain/usecases/share_export_file.dart';
import '../../features/export/presentation/cubit/export_cubit.dart';
import '../../features/budgets/domain/repositories/budget_repository.dart';
import '../../features/categories/domain/repositories/category_repository.dart';
import '../../features/expenses/domain/repositories/expense_repository.dart';
import '../../features/recurring/domain/repositories/recurring_expense_repository.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/dashboard/domain/usecases/get_dashboard_summary.dart';
import '../../features/dashboard/domain/usecases/get_top_categories.dart';
import '../../features/dashboard/domain/usecases/get_weekly_spending.dart';

Future<void> registerExportFeature(GetIt sl) async {
  // Export Data Sources
  if (!sl.isRegistered<ExportHistoryLocalDataSource>()) {
    sl.registerLazySingleton<ExportHistoryLocalDataSource>(
      () => HiveExportHistoryLocalDataSource(
        sl<Box<Map>>(instanceName: HiveExportHistoryLocalDataSource.boxName),
      ),
    );
  }

  if (!sl.isRegistered<ExportFileLocalDataSource>()) {
    sl.registerLazySingleton<ExportFileLocalDataSource>(
      () => ExportFileLocalDataSourceImpl(),
    );
  }

  // Export Builders
  if (!sl.isRegistered<ExportPdfBuilder>()) {
    sl.registerLazySingleton<ExportPdfBuilder>(() => const ExportPdfBuilder());
  }

  if (!sl.isRegistered<ExpensesExportPayloadBuilder>()) {
    sl.registerLazySingleton<ExpensesExportPayloadBuilder>(
      () => const ExpensesExportPayloadBuilder(),
    );
  }

  if (!sl.isRegistered<BackupPayloadBuilder>()) {
    sl.registerLazySingleton<BackupPayloadBuilder>(
      () => const BackupPayloadBuilder(),
    );
  }

  if (!sl.isRegistered<PdfReportContentBuilder>()) {
    sl.registerLazySingleton<PdfReportContentBuilder>(
      () => const PdfReportContentBuilder(),
    );
  }

  // Export Repository
  if (!sl.isRegistered<ExportRepository>()) {
    sl.registerLazySingleton<ExportRepository>(
      () => ExportRepositoryImpl(
        expenseRepository: sl<ExpenseRepository>(),
        categoryRepository: sl<CategoryRepository>(),
        budgetRepository: sl<BudgetRepository>(),
        recurringRepository: sl<RecurringExpenseRepository>(),
        settingsRepository: sl<SettingsRepository>(),
        files: sl<ExportFileLocalDataSource>(),
        history: sl<ExportHistoryLocalDataSource>(),
        pdfBuilder: sl<ExportPdfBuilder>(),
        getDashboardSummary: sl<GetDashboardSummary>(),
        getTopCategories: sl<GetTopCategories>(),
        getWeeklySpending: sl<GetWeeklySpending>(),
        expensesPayload: sl<ExpensesExportPayloadBuilder>(),
        backupPayload: sl<BackupPayloadBuilder>(),
        pdfContent: sl<PdfReportContentBuilder>(),
      ),
    );
  }

  // Export Use Cases
  if (!sl.isRegistered<ExportExpensesAsCsv>()) {
    sl.registerLazySingleton<ExportExpensesAsCsv>(
      () => ExportExpensesAsCsv(sl<ExportRepository>()),
    );
  }

  if (!sl.isRegistered<ExportExpensesAsJson>()) {
    sl.registerLazySingleton<ExportExpensesAsJson>(
      () => ExportExpensesAsJson(sl<ExportRepository>()),
    );
  }

  if (!sl.isRegistered<ExportExpensesAsPdf>()) {
    sl.registerLazySingleton<ExportExpensesAsPdf>(
      () => ExportExpensesAsPdf(sl<ExportRepository>()),
    );
  }

  if (!sl.isRegistered<ExportAllData>()) {
    sl.registerLazySingleton<ExportAllData>(
      () => ExportAllData(sl<ExportRepository>()),
    );
  }

  if (!sl.isRegistered<SaveExportFile>()) {
    sl.registerLazySingleton<SaveExportFile>(
      () => SaveExportFile(sl<ExportRepository>()),
    );
  }

  if (!sl.isRegistered<ShareExportFile>()) {
    sl.registerLazySingleton<ShareExportFile>(
      () => ShareExportFile(sl<ExportRepository>()),
    );
  }

  if (!sl.isRegistered<GetExportHistory>()) {
    sl.registerLazySingleton<GetExportHistory>(
      () => GetExportHistory(sl<ExportRepository>()),
    );
  }

  if (!sl.isRegistered<DeleteExportHistory>()) {
    sl.registerLazySingleton<DeleteExportHistory>(
      () => DeleteExportHistory(sl<ExportRepository>()),
    );
  }

  // Export Cubit
  if (!sl.isRegistered<ExportCubit>()) {
    sl.registerFactory<ExportCubit>(
      () => ExportCubit(
        exportExpensesAsCsv: sl<ExportExpensesAsCsv>(),
        exportExpensesAsJson: sl<ExportExpensesAsJson>(),
        exportExpensesAsPdf: sl<ExportExpensesAsPdf>(),
        exportAllData: sl<ExportAllData>(),
        saveExportFile: sl<SaveExportFile>(),
        shareExportFile: sl<ShareExportFile>(),
        getExportHistory: sl<GetExportHistory>(),
        deleteExportHistory: sl<DeleteExportHistory>(),
      ),
    );
  }
}
