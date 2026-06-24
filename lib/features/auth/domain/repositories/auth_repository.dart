import '../entities/user.dart';

abstract class AuthRepository {
  Future<AppUser?> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<AppUser?> signUpWithEmailPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<AppUser?> getCurrentUser();
}