import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel?> getProfile(String userId);

  Future<void> upsertProfile(ProfileModel profile);
}

class SupabaseProfileRemoteDataSource implements ProfileRemoteDataSource {
  final SupabaseClient _client;

  static const String tableName = 'profiles';

  const SupabaseProfileRemoteDataSource(this._client);

  @override
  Future<ProfileModel?> getProfile(String userId) async {
    final response = await _client
        .from(tableName)
        .select()
        .eq('id', userId)
        .maybeSingle();
    if (response == null) return null;
    return ProfileModel.fromJson(Map<String, dynamic>.from(response));
  }

  @override
  Future<void> upsertProfile(ProfileModel profile) async {
    await _client.from(tableName).upsert(profile.toJson());
  }
}
