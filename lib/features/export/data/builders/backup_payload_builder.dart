import 'dart:convert';

import 'package:hive/hive.dart';

class BackupPayloadBuilder {
  const BackupPayloadBuilder();

  Future<Object> build({
    required String appName,
    required List<String> boxNames,
  }) async {
    final payload = <String, Object?>{
      'app': appName,
      'generatedAt': DateTime.now().toIso8601String(),
    };

    for (final name in boxNames) {
      final box = Hive.isBoxOpen(name) ? Hive.box<Map>(name) : await Hive.openBox<Map>(name);
      payload[name] = box.values.map((m) => _safeJson(m)).toList(growable: false);
    }

    return payload;
  }

  Map<String, dynamic> _safeJson(Map input) {
    return jsonDecode(jsonEncode(input)) as Map<String, dynamic>;
  }
}

