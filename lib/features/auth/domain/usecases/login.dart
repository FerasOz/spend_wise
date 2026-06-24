import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  const LoginUseCase(this._authRepository);

  Future<AppUser?> call({
    required String email,
    required String password,
  }) async {
    return await _authRepository.signInWithEmailPassword(
      email: email,
      password: password,
    );
  }
}