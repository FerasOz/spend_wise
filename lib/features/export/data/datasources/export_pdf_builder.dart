import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ExportPdfBuilder {
  const ExportPdfBuilder();

  Future<Uint8List> buildSimpleReport({
    required String appName,
    required String generatedAt,
    required String totalSpending,
    required String topCategory,
    required List<String> recentExpenses,
    required List<String> weeklySummary,
  }) {
    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (_) => [
          pw.Text(
            appName,
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.Text('Generated: $generatedAt', style: const pw.TextStyle(fontSize: 10)),
          pw.SizedBox(height: 16),
          pw.Text('Total spending: $totalSpending', style: const pw.TextStyle(fontSize: 14)),
          pw.Text('Top category: $topCategory', style: const pw.TextStyle(fontSize: 12)),
          pw.SizedBox(height: 16),
          pw.Text('Recent expenses', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 6),
          ...recentExpenses.map((e) => pw.Text('- $e')),
          pw.SizedBox(height: 16),
          pw.Text('Weekly summary', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 6),
          ...weeklySummary.map((e) => pw.Text('- $e')),
        ],
      ),
    );
    return doc.save();
  }
}

