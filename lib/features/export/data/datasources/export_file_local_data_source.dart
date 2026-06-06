import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/export_type.dart';
import '../../domain/entities/export_file_result.dart';

import '../../../../core/services/app_clock.dart';

abstract class ExportFileLocalDataSource {
  Future<ExportFileResult> writeCsv({
    required String fileNameBase,
    required List<List<dynamic>> rows,
    required AppClock clock,
  });

  Future<ExportFileResult> writeJson({
    required String fileNameBase,
    required Object json,
    required ExportType type,
    required AppClock clock,
  });

  Future<ExportFileResult> writePdf({
    required String fileNameBase,
    required Uint8List bytes,
    required AppClock clock,
  });

  Future<String> copyToDownloads(String path);
}

class ExportFileLocalDataSourceImpl implements ExportFileLocalDataSource {
  static const _folderName = 'SpendWise/exports';

  @override
  Future<ExportFileResult> writeCsv({
    required String fileNameBase,
    required List<List<dynamic>> rows,
    required AppClock clock,
  }) async {
    final createdAt = clock.now();
    final fileName = '$fileNameBase.${ExportType.csv.extension}';
    final file = await _createFile(fileName);
    await file.writeAsString(const ListToCsvConverter().convert(rows));
    return _result(file, fileName, createdAt, ExportType.csv);
  }

  @override
  Future<ExportFileResult> writeJson({
    required String fileNameBase,
    required Object json,
    required ExportType type,
    required AppClock clock,
  }) async {
    final createdAt = clock.now();
    final fileName = '$fileNameBase.${type.extension}';
    final file = await _createFile(fileName);
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(json));
    return _result(file, fileName, createdAt, type);
  }

  @override
  Future<ExportFileResult> writePdf({
    required String fileNameBase,
    required Uint8List bytes,
    required AppClock clock,
  }) async {
    final createdAt = clock.now();
    final fileName = '$fileNameBase.${ExportType.pdf.extension}';
    final file = await _createFile(fileName);
    await file.writeAsBytes(bytes);
    return _result(file, fileName, createdAt, ExportType.pdf);
  }

  @override
  Future<String> copyToDownloads(String path) async {
    final file = File(path);
    final downloadsDir = await getDownloadsDirectory();
    final baseDir = downloadsDir ?? await getApplicationDocumentsDirectory();
    final targetDir = Directory('${baseDir.path}/$_folderName');
    await targetDir.create(recursive: true);
    final fileName = file.uri.pathSegments.last;
    return file.copy('${targetDir.path}/$fileName').then((f) => f.path);
  }

  Future<File> _createFile(String fileName) async {
    final docs = await getApplicationDocumentsDirectory();
    final directory = Directory('${docs.path}/$_folderName');
    await directory.create(recursive: true);
    final file = File('${directory.path}/$fileName');
    await file.create(recursive: true);
    return file;
  }

  ExportFileResult _result(
    File file,
    String fileName,
    DateTime createdAt,
    ExportType type,
  ) {
    return ExportFileResult(
      path: file.path,
      fileName: fileName,
      createdAt: createdAt,
      sizeBytes: file.lengthSync(),
      type: type,
    );
  }
}

