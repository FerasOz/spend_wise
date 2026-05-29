import '../repositories/export_repository.dart';

class ShareExportFile {
  const ShareExportFile(this._repository);
  final ExportRepository _repository;

  Future<void> call(String path) => _repository.shareFile(path);
}

