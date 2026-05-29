import 'export_type.dart';

class ExportFileResult {
  const ExportFileResult({
    required this.path,
    required this.fileName,
    required this.createdAt,
    required this.sizeBytes,
    required this.type,
  });

  final String path;
  final String fileName;
  final DateTime createdAt;
  final int sizeBytes;
  final ExportType type;
}

