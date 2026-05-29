import '../entities/export_history_item.dart';
import '../repositories/export_repository.dart';

class GetExportHistory {
  const GetExportHistory(this._repository);
  final ExportRepository _repository;

  Future<List<ExportHistoryItem>> call() => _repository.getHistory();
}

