part of 'export_repository_impl.dart';

extension _ExportRepositoryBackupX on ExportRepositoryImpl {
  Future<ExportFile> _exportAllData() async {
    final payload = await _backupPayload.build(
      appName: 'SpendWise',
      boxNames: const [
        HiveCategoryLocalDataSource.boxName,
        HiveExpenseLocalDataSource.boxName,
        HiveBudgetLocalDataSource.boxName,
        HiveRecurringExpenseLocalDataSource.boxName,
        HiveSettingsLocalDataSource.boxName,
      ],
    );

    final result = await _files.writeJson(
      fileNameBase: ExportFileNameBuilder.build(ExportType.backup),
      json: payload,
      type: ExportType.backup,
    );
    return _toExportFile(await _storeHistory(result));
  }
}

