import 'package:hive/hive.dart';

import '../models/export_history_item_model.dart';

abstract class ExportHistoryLocalDataSource {
  Future<List<ExportHistoryItemModel>> getHistory();
  Future<void> upsert(ExportHistoryItemModel item);
  Future<void> delete(String id);
}

class HiveExportHistoryLocalDataSource implements ExportHistoryLocalDataSource {
  const HiveExportHistoryLocalDataSource(this._box);

  static const String boxName = 'export_history_box';
  final Box<Map> _box;

  @override
  Future<List<ExportHistoryItemModel>> getHistory() async {
    final items = _box.values
        .map((m) => ExportHistoryItemModel.fromJson(Map<String, dynamic>.from(m)))
        .toList(growable: false)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  @override
  Future<void> upsert(ExportHistoryItemModel item) async {
    await _box.put(item.id, item.toJson());
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}

