import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_settings_model.dart';

abstract class SettingsRemoteDataSource {
  Future<UserSettingsModel?> getUserSettings(String userId);

  Future<void> upsertUserSettings(String userId, UserSettingsModel settings);
}

class SupabaseSettingsRemoteDataSource implements SettingsRemoteDataSource {
  final SupabaseClient _client;

  static const String tableName = 'user_settings';

  const SupabaseSettingsRemoteDataSource(this._client);

  @override
  Future<UserSettingsModel?> getUserSettings(String userId) async {
    final response = await _client
        .from(tableName)
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    if (response == null) return null;
    return UserSettingsModel.fromJson(Map<String, dynamic>.from(response));
  }

  @override
  Future<void> upsertUserSettings(
    String userId,
    UserSettingsModel settings,
  ) async {
    await _client.from(tableName).upsert({
      'user_id': userId,
      ...settings.toJson(),
    });
  }
}
