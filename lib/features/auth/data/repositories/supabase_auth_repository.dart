import 'package:spend_wise/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _supabase;

  const SupabaseAuthRepository(this._supabase);

  @override
  Future<AppUser?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) return null;
      return AppUser(
        uid: user.id,
        email: user.email ?? '',
        displayName: user.userMetadata?['full_name'] as String?,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserModel?> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': name},
      );
      final user = response.user;
      if (user == null) return null;

      return UserModel(
        uid: user.id,
        email: user.email ?? '',
        displayName: name,
        requiresEmailConfirmation: response.session == null,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;
    return AppUser(
      uid: user.id,
      email: user.email ?? '',
      displayName: user.userMetadata?['full_name'] as String?,
    );
  }
}
