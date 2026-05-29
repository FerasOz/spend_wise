enum ExportType { csv, json, pdf, backup }

extension ExportTypeX on ExportType {
  String get key {
    return switch (this) {
      ExportType.csv => 'csv',
      ExportType.json => 'json',
      ExportType.pdf => 'pdf',
      ExportType.backup => 'backup',
    };
  }

  String get extension {
    return switch (this) {
      ExportType.csv => 'csv',
      ExportType.json => 'json',
      ExportType.pdf => 'pdf',
      ExportType.backup => 'json',
    };
  }

  String get label {
    return switch (this) {
      ExportType.csv => 'CSV',
      ExportType.json => 'JSON',
      ExportType.pdf => 'PDF',
      ExportType.backup => 'Backup',
    };
  }
}

