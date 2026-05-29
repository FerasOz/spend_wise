part of 'export_repository_impl.dart';

extension _ExportRepositoryHistoryX on ExportRepositoryImpl {
  Future<ExportHistoryItemModel> _storeHistory(ExportFileResult result) async {
    final id = '${result.type.key}_${result.createdAt.microsecondsSinceEpoch}';
    final item = ExportHistoryItemModel(
      id: id,
      path: result.path,
      fileName: result.fileName,
      createdAt: result.createdAt,
      sizeBytes: result.sizeBytes,
      type: result.type,
    );
    await _history.upsert(item);
    return item;
  }

  ExportFile _toExportFile(ExportHistoryItemModel item) {
    return ExportFile(
      path: item.path,
      fileName: item.fileName,
      createdAt: item.createdAt,
      sizeBytes: item.sizeBytes,
      type: item.type,
    );
  }
}

