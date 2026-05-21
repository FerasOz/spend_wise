import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../../domain/services/export_service.dart';
import '../../../expenses/domain/entities/expense.dart';
import '../../../categories/domain/entities/category.dart';

class ExportServiceImpl implements ExportService {
  @override
  Future<String> exportExpensesAsCSV(
    List<Expense> expenses,
    Map<String, Category> categoriesMap,
  ) async {
    final buffer = StringBuffer();

    // CSV Header
    buffer.writeln('Title,Amount,Category,Date,Note');

    // CSV Rows
    for (final expense in expenses) {
      final category = categoriesMap[expense.categoryId]?.name ?? 'Unknown';
      final date =
          '${expense.date.year}-${expense.date.month.toString().padLeft(2, '0')}-${expense.date.day.toString().padLeft(2, '0')}';
      final note = _escapeCsvField(expense.note ?? '');
      final title = _escapeCsvField(expense.title);

      buffer.writeln('$title,${expense.amount},$category,$date,$note');
    }

    // Save to file
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final directory = await _getExportDirectory();
    final file = File('${directory.path}/expenses_$timestamp.csv');

    await file.create(recursive: true);
    await file.writeAsString(buffer.toString());

    return file.path;
  }

  @override
  Future<Uint8List> exportDashboardSummaryAsPDF(
    List<Expense> expenses,
    Map<String, Category> categoriesMap,
  ) async {
    final pdf = pw.Document();
    final totalSpending = expenses.fold<double>(0, (sum, e) => sum + e.amount);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Spend Wise - Spending Summary',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Total Spending: \$${totalSpending.toStringAsFixed(2)}',
              style: pw.TextStyle(fontSize: 16),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'By Category:',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            ..._buildCategoryRows(categoriesMap, expenses, totalSpending),
            pw.SizedBox(height: 20),
            pw.Text(
              'Generated on: ${DateTime.now().toString()}',
              style: pw.TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );

    return await pdf.save();
  }

  @override
  Future<void> createBackup() async {
    // TODO: Implement Hive backup functionality
    // This would serialize all Hive boxes to a backup file
  }

  @override
  Future<void> restoreBackup(String backupPath) async {
    // TODO: Implement Hive restore functionality
    // This would deserialize backup file to restore Hive boxes
  }

  @override
  Future<List<String>> getAvailableBackups() async {
    // TODO: Implement backup listing functionality
    // For now, return empty list
    return [];
  }

  @override
  Future<void> deleteBackup(String backupPath) async {
    final file = File(backupPath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<Directory> _getExportDirectory() async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Documents/SpendWise');
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  String _escapeCsvField(String field) {
    if (field.contains(',') || field.contains('"') || field.contains('\n')) {
      return '"${field.replaceAll('"', '""')}"';
    }
    return field;
  }

  List<pw.Widget> _buildCategoryRows(
    Map<String, Category> categoriesMap,
    List<Expense> expenses,
    double totalSpending,
  ) {
    final categoryTotals = <String, double>{};
    for (final expense in expenses) {
      categoryTotals[expense.categoryId] =
          (categoryTotals[expense.categoryId] ?? 0) + expense.amount;
    }

    final rows = <pw.Widget>[];
    for (final entry in categoryTotals.entries) {
      final category = categoriesMap[entry.key]?.name ?? 'Unknown';
      final percentage = (entry.value / totalSpending * 100).toStringAsFixed(1);
      rows.add(
        pw.Text(
          '\$${entry.value.toStringAsFixed(2)} - $category ($percentage%)',
          style: pw.TextStyle(fontSize: 12),
        ),
      );
      rows.add(pw.SizedBox(height: 5));
    }

    return rows;
  }
}
