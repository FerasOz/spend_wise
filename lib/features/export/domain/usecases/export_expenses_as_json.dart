import '../entities/export_file.dart';
import '../entities/export_type.dart';
import '../repositories/export_repository.dart';

class ExportExpensesAsJson {
  const ExportExpensesAsJson(this._repository);
  final ExportRepository _repository;

  Future<ExportFile> call() => _repository.exportExpenses(ExportType.json);
}

