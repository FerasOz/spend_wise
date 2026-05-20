part of 'export_cubit.dart';

class ExportState {
  const ExportState.initial()
    : isLoading = false,
      filePath = null,
      exportType = null,
      error = null,
      isBackupSuccess = false;

  const ExportState.loading()
    : isLoading = true,
      filePath = null,
      exportType = null,
      error = null,
      isBackupSuccess = false;

  const ExportState.success(String filePath, String exportType)
    : isLoading = false,
      filePath = filePath,
      exportType = exportType,
      error = null,
      isBackupSuccess = false;

  const ExportState.error(String error)
    : isLoading = false,
      filePath = null,
      exportType = null,
      error = error,
      isBackupSuccess = false;

  const ExportState.backupSuccess()
    : isLoading = false,
      filePath = null,
      exportType = null,
      error = null,
      isBackupSuccess = true;

  final bool isLoading;
  final String? filePath;
  final String? exportType;
  final String? error;
  final bool isBackupSuccess;
}
