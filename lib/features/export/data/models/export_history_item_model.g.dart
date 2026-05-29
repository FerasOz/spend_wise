// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_history_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExportHistoryItemModel _$ExportHistoryItemModelFromJson(
  Map<String, dynamic> json,
) => ExportHistoryItemModel(
  id: json['id'] as String,
  path: json['path'] as String,
  fileName: json['fileName'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  sizeBytes: (json['sizeBytes'] as num).toInt(),
  type: const ExportTypeConverter().fromJson(json['type'] as String),
);

Map<String, dynamic> _$ExportHistoryItemModelToJson(
  ExportHistoryItemModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'path': instance.path,
  'fileName': instance.fileName,
  'createdAt': instance.createdAt.toIso8601String(),
  'sizeBytes': instance.sizeBytes,
  'type': const ExportTypeConverter().toJson(instance.type),
};
