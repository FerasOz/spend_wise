import 'export_type.dart';

class ExportHistoryItem {
  const ExportHistoryItem({
    required this.id,
    required this.path,
    required this.fileName,
    required this.createdAt,
    required this.sizeBytes,
    required this.type,
  });

  final String id;
  final String path;
  final String fileName;
  final DateTime createdAt;
  final int sizeBytes;
  final ExportType type;
}

