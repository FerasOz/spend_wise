import '../entities/export_file.dart';
import '../repositories/export_repository.dart';

class ExportExpensesAsPdf {
  const ExportExpensesAsPdf(this._repository);
  final ExportRepository _repository;

  Future<ExportFile> call() => _repository.exportPdfReport();
}

