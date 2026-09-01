import 'package:spend_wise/features/auth/data/models/user_model.dart';

import '../entities/user.dart';

abstract class AuthRepository {
  Future<AppUser?> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<AppUser?> getCurrentUser();
}