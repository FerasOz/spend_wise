import '../entities/export_file.dart';
import '../repositories/export_repository.dart';

class ExportAllData {
  const ExportAllData(this._repository);
  final ExportRepository _repository;

  Future<ExportFile> call() => _repository.exportAllData();
}

