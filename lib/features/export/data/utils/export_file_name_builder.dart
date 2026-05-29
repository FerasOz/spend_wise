import '../../domain/entities/export_type.dart';

class ExportFileNameBuilder {
  const ExportFileNameBuilder._();

  static String build(ExportType type) {
    final now = DateTime.now();
    final ts =
        '${now.year}${_two(now.month)}${_two(now.day)}_${_two(now.hour)}${_two(now.minute)}${_two(now.second)}';
    return switch (type) {
      ExportType.csv => 'expenses_$ts',
      ExportType.json => 'expenses_$ts',
      ExportType.pdf => 'report_$ts',
      ExportType.backup => 'backup_$ts',
    };
  }

  static String _two(int v) => v.toString().padLeft(2, '0');
}

