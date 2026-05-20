import 'dart:typed_data';

import '../../../expenses/domain/entities/expense.dart';
import '../../../categories/domain/entities/category.dart';

abstract class ExportService {
  Future<String> exportExpensesAsCSV(
    List<Expense> expenses,
    Map<String, Category> categoriesMap,
  );

  Future<Uint8List> exportDashboardSummaryAsPDF(
    List<Expense> expenses,
    Map<String, Category> categoriesMap,
  );

  Future<void> createBackup();

  Future<void> restoreBackup(String backupPath);

  Future<List<String>> getAvailableBackups();

  Future<void> deleteBackup(String backupPath);
}
