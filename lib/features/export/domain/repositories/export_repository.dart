import '../entities/export_file.dart';
import '../entities/export_history_item.dart';
import '../entities/export_type.dart';

abstract class ExportRepository {
  Future<ExportFile> exportExpenses(ExportType type);
  Future<ExportFile> exportPdfReport();
  Future<ExportFile> exportAllData();

  Future<void> shareFile(String path);
  Future<void> saveFileToDownloads(String path);

  Future<List<ExportHistoryItem>> getHistory();
  Future<void> deleteHistoryItem(String id);
}

