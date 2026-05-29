import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/export_history_item.dart';
import '../../domain/entities/export_type.dart';

part 'export_history_item_model.g.dart';

class ExportTypeConverter implements JsonConverter<ExportType, String> {
  const ExportTypeConverter();

  @override
  ExportType fromJson(String json) {
    return ExportType.values.firstWhere(
      (t) => t.key == json,
      orElse: () => ExportType.csv,
    );
  }

  @override
  String toJson(ExportType object) => object.key;
}

@JsonSerializable()
class ExportHistoryItemModel {
  const ExportHistoryItemModel({
    required this.id,
    required this.path,
    required this.fileName,
    required this.createdAt,
    required this.sizeBytes,
    required this.type,
  });

  final String id;
  final String path;
  final String fileName;
  final DateTime createdAt;
  final int sizeBytes;
  @ExportTypeConverter()
  final ExportType type;

  factory ExportHistoryItemModel.fromJson(Map<String, dynamic> json) =>
      _$ExportHistoryItemModelFromJson(json);

  factory ExportHistoryItemModel.fromEntity(ExportHistoryItem item) {
    return ExportHistoryItemModel(
      id: item.id,
      path: item.path,
      fileName: item.fileName,
      createdAt: item.createdAt,
      sizeBytes: item.sizeBytes,
      type: item.type,
    );
  }

  Map<String, dynamic> toJson() => _$ExportHistoryItemModelToJson(this);

  ExportHistoryItem toEntity() {
    return ExportHistoryItem(
      id: id,
      path: path,
      fileName: fileName,
      createdAt: createdAt,
      sizeBytes: sizeBytes,
      type: type,
    );
  }
}
