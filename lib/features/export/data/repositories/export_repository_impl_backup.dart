part of 'export_repository_impl.dart';

extension _ExportRepositoryBackupX on ExportRepositoryImpl {
  Future<ExportFile> _exportAllData() async {
    final categories = await _categories.getCategories();
    final expenses = await _expenses.getExpenses();
    final budgets = await _budgets.getBudgets();
    final recurring = await _recurring.getRecurringExpenses();
    final settings = await _settings.getSettings();

    final payload = _backupPayload.build(
      appName: 'SpendWise',
      clock: _clock,
      collections: {
        HiveCategoryLocalDataSource.boxName: categories
            .map((category) => CategoryModel.fromEntity(category).toJson())
            .toList(growable: false),
        HiveExpenseLocalDataSource.boxName: expenses
            .map((expense) => ExpenseModel.fromEntity(expense).toJson())
            .toList(growable: false),
        HiveBudgetLocalDataSource.boxName: budgets
            .map((budget) => BudgetModel.fromEntity(budget).toJson())
            .toList(growable: false),
        HiveRecurringExpenseLocalDataSource.boxName: recurring
            .map((item) => RecurringExpenseModel.fromEntity(item).toJson())
            .toList(growable: false),
        HiveSettingsLocalDataSource.boxName: settings.toJson(),
      },
    );

    final result = await _files.writeJson(
      fileNameBase: ExportFileNameBuilder.build(ExportType.backup, _clock),
      json: payload,
      type: ExportType.backup,
      clock: _clock,
    );
    return _toExportFile(await _storeHistory(result));
  }
}

