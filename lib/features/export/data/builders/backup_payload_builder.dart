class BackupPayloadBuilder {
  const BackupPayloadBuilder();

  Map<String, Object?> build({
    required String appName,
    required Map<String, Object?> collections,
  }) {
    return {
      'app': appName,
      'generatedAt': DateTime.now().toIso8601String(),
      ...collections,
    };
  }
}
