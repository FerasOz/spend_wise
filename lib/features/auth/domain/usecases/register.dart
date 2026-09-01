import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;

  const RegisterUseCase(this._authRepository);

  Future<AppUser?> call({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _authRepository.signUpWithEmailPassword(
      name: name,
      email: email,
      password: password,
    );
  }
}