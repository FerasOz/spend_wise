import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/profiles/domain/entities/profile.dart';
import 'package:spend_wise/features/profiles/domain/repositories/profile_repository.dart';
import 'package:spend_wise/features/settings/domain/repositories/settings_repository.dart';
import 'package:spend_wise/core/services/user_data_scope.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/register.dart';
import '../../domain/usecases/logout.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required ProfileRepository profileRepository,
    required SettingsRepository settingsRepository,
    required UserDataScope userDataScope,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _logoutUseCase = logoutUseCase,
       _profileRepository = profileRepository,
       _settingsRepository = settingsRepository,
       _userDataScope = userDataScope,
       super(const AuthState());

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final ProfileRepository _profileRepository;
  final SettingsRepository _settingsRepository;
  final UserDataScope _userDataScope;

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    try {
      final user = await _loginUseCase(email: email, password: password);
      if (user != null) {
        await _initializeAuthenticatedUserData(user);
        emit(state.copyWith(status: AuthStatus.success, user: user));
      } else {
        emit(
          state.copyWith(
            status: AuthStatus.error,
            errorMessage: 'Invalid email or password',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Login failed: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    try {
      final user = await _registerUseCase(
        name: name,
        email: email,
        password: password,
      );
      if (user != null) {
        if (user.requiresEmailConfirmation) {
          emit(
            state.copyWith(
              status: AuthStatus.emailVerificationRequired,
              user: user,
              errorMessage:
                  'Registration successful. Please confirm your email before signing in.',
            ),
          );
        } else {
          await _initializeAuthenticatedUserData(user);
          emit(state.copyWith(status: AuthStatus.success, user: user));
        }
      } else {
        emit(
          state.copyWith(
            status: AuthStatus.error,
            errorMessage: 'Registration failed. Please try again.',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Registration failed: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> logout() async {
    await _logoutUseCase();
    emit(const AuthState(status: AuthStatus.initial));
  }

  Future<void> _initializeAuthenticatedUserData(AppUser user) async {
    try {
      await _userDataScope.prepareForUser(user.uid);
      final existingProfile = await _profileRepository.getProfile(user.uid);
      final profile = Profile(
        id: user.uid,
        displayName:
            existingProfile?.displayName ??
            user.displayName ??
            user.email.split('@').first,
        createdAt: existingProfile?.createdAt ?? DateTime.now(),
      );
      await _profileRepository.createProfile(profile);
      await _settingsRepository.getSettings();
    } catch (_) {}
  }
}
