import '../../domain/entities/export_type.dart';
import 'package:spend_wise/core/services/app_clock.dart';

class ExportFileNameBuilder {
  const ExportFileNameBuilder._();

  static String build(ExportType type, AppClock clock) {
    final now = clock.now();
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

