import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/services/export_service.dart';
import '../../../expenses/domain/entities/expense.dart';
import '../../../categories/domain/entities/category.dart';

part 'export_state.dart';

class ExportCubit extends Cubit<ExportState> {
  ExportCubit(this._exportService) : super(const ExportState.initial());

  final ExportService _exportService;

  Future<void> exportExpensesAsCSV(
    List<Expense> expenses,
    Map<String, Category> categoriesMap,
  ) async {
    try {
      emit(const ExportState.loading());
      final filePath = await _exportService.exportExpensesAsCSV(
        expenses,
        categoriesMap,
      );
      emit(ExportState.success(filePath, 'CSV'));
    } catch (e) {
      emit(ExportState.error(e.toString()));
    }
  }

  Future<void> exportDashboardSummaryAsPDF(
    List<Expense> expenses,
    Map<String, Category> categoriesMap,
  ) async {
    try {
      emit(const ExportState.loading());
      final pdfBytes = await _exportService.exportDashboardSummaryAsPDF(
        expenses,
        categoriesMap,
      );
      final now = DateTime.now();
      final fileName =
          'summary_${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}.pdf';
      final directory = await _getExportDirectory();
      final file = File('${directory.path}/$fileName');
      await file.create(recursive: true);
      await file.writeAsBytes(pdfBytes);
      emit(ExportState.success(file.path, 'PDF'));
    } catch (e) {
      emit(ExportState.error(e.toString()));
    }
  }

  Future<void> createBackup() async {
    try {
      emit(const ExportState.loading());
      await _exportService.createBackup();
      emit(const ExportState.backupSuccess());
    } catch (e) {
      emit(ExportState.error(e.toString()));
    }
  }

  void resetState() => emit(const ExportState.initial());

  Future<Directory> _getExportDirectory() async {
    final directory = Directory('/storage/emulated/0/Documents/SpendWise');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }
}
