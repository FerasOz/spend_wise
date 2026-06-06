import 'package:spend_wise/core/services/app_clock.dart';

class BackupPayloadBuilder {
  const BackupPayloadBuilder();

  Map<String, Object?> build({
    required String appName,
    required Map<String, Object?> collections,
    required AppClock clock,
  }) {
    return {
      'app': appName,
      'generatedAt': clock.now().toIso8601String(),
      ...collections,
    };
  }
}
