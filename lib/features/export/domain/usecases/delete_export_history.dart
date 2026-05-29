import '../repositories/export_repository.dart';

class DeleteExportHistory {
  const DeleteExportHistory(this._repository);
  final ExportRepository _repository;

  Future<void> call(String id) => _repository.deleteHistoryItem(id);
}

