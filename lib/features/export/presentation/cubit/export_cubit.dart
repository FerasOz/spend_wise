import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/export_file.dart';
import '../../domain/entities/export_history_item.dart';
import '../../domain/usecases/delete_export_history.dart';
import '../../domain/usecases/export_all_data.dart';
import '../../domain/usecases/export_expenses_as_csv.dart';
import '../../domain/usecases/export_expenses_as_json.dart';
import '../../domain/usecases/export_expenses_as_pdf.dart';
import '../../domain/usecases/get_export_history.dart';
import '../../domain/usecases/save_export_file.dart';
import '../../domain/usecases/share_export_file.dart';

part 'export_state.dart';

class ExportCubit extends Cubit<ExportState> {
  ExportCubit({
    required ExportExpensesAsCsv exportExpensesAsCsv,
    required ExportExpensesAsJson exportExpensesAsJson,
    required ExportExpensesAsPdf exportExpensesAsPdf,
    required ExportAllData exportAllData,
    required GetExportHistory getExportHistory,
    required DeleteExportHistory deleteExportHistory,
    required ShareExportFile shareExportFile,
    required SaveExportFile saveExportFile,
  }) : _exportExpensesAsCsv = exportExpensesAsCsv,
       _exportExpensesAsJson = exportExpensesAsJson,
       _exportExpensesAsPdf = exportExpensesAsPdf,
       _exportAllData = exportAllData,
       _getExportHistory = getExportHistory,
       _deleteExportHistory = deleteExportHistory,
       _shareExportFile = shareExportFile,
       _saveExportFile = saveExportFile,
       super(const ExportState.initial());

  final ExportExpensesAsCsv _exportExpensesAsCsv;
  final ExportExpensesAsJson _exportExpensesAsJson;
  final ExportExpensesAsPdf _exportExpensesAsPdf;
  final ExportAllData _exportAllData;
  final GetExportHistory _getExportHistory;
  final DeleteExportHistory _deleteExportHistory;
  final ShareExportFile _shareExportFile;
  final SaveExportFile _saveExportFile;

  Future<void> loadHistory() async {
    emit(state.copyWith(isLoadingHistory: true, errorMessage: null));
    try {
      final history = await _getExportHistory();
      emit(state.copyWith(isLoadingHistory: false, history: history));
    } catch (e) {
      emit(state.copyWith(isLoadingHistory: false, errorMessage: e.toString()));
    }
  }

  Future<void> exportCsv() => _export(() => _exportExpensesAsCsv());
  Future<void> exportJson() => _export(() => _exportExpensesAsJson());
  Future<void> exportPdf() => _export(() => _exportExpensesAsPdf());
  Future<void> exportBackup() => _export(() => _exportAllData());

  Future<void> share(String path) async {
    emit(
      state.copyWith(
        isSharing: true,
        errorMessage: null,
        clearLastAction: true,
      ),
    );
    try {
      await _shareExportFile(path);
      emit(state.copyWith(isSharing: false, lastAction: ExportAction.shared));
    } catch (e) {
      emit(state.copyWith(isSharing: false, errorMessage: e.toString()));
    }
  }

  Future<void> saveToDownloads(String path) async {
    emit(
      state.copyWith(
        isSaving: true,
        errorMessage: null,
        clearLastAction: true,
      ),
    );
    try {
      await _saveExportFile(path);
      emit(state.copyWith(isSaving: false, lastAction: ExportAction.saved));
    } catch (e) {
      emit(state.copyWith(isSaving: false, errorMessage: e.toString()));
    }
  }

  Future<void> deleteHistoryItem(String id) async {
    emit(state.copyWith(isDeleting: true, errorMessage: null));
    try {
      await _deleteExportHistory(id);
      final history = await _getExportHistory();
      emit(state.copyWith(isDeleting: false, history: history));
    } catch (e) {
      emit(state.copyWith(isDeleting: false, errorMessage: e.toString()));
    }
  }

  void clearFeedback() => emit(
    state.copyWith(errorMessage: null, clearLastAction: true),
  );

  Future<void> _export(Future<ExportFile> Function() run) async {
    emit(
      state.copyWith(
        isExporting: true,
        errorMessage: null,
        clearLastExport: true,
      ),
    );
    try {
      final file = await run();
      final history = await _getExportHistory();
      emit(state.copyWith(isExporting: false, lastExport: file, history: history));
    } catch (e) {
      emit(state.copyWith(isExporting: false, errorMessage: e.toString()));
    }
  }
}
