import '../repositories/export_repository.dart';

class SaveExportFile {
  const SaveExportFile(this._repository);
  final ExportRepository _repository;

  Future<void> call(String path) => _repository.saveFileToDownloads(path);
}

