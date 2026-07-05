import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/profile.dart';
import '../../domain/usecases/create_profile.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required GetProfile getProfile,
    required CreateProfile createProfile,
    required UpdateProfile updateProfile,
  }) : _getProfile = getProfile,
       _createProfile = createProfile,
       _updateProfile = updateProfile,
       super(const ProfileState());

  final GetProfile _getProfile;
  final CreateProfile _createProfile;
  final UpdateProfile _updateProfile;

  Future<void> loadProfile(String userId) async {
    emit(state.copyWith(status: ProfileStatus.loading, error: null));
    try {
      final profile = await _getProfile(userId);
      if (profile != null) {
        emit(state.copyWith(status: ProfileStatus.success, profile: profile));
      } else {
        emit(
          state.copyWith(
            status: ProfileStatus.error,
            error: 'Profile not found',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.error, error: e.toString()));
    }
  }

  Future<void> createOrUpdateProfile(Profile profile) async {
    emit(state.copyWith(status: ProfileStatus.loading, error: null));
    try {
      if (state.profile == null) {
        await _createProfile(profile);
      } else {
        await _updateProfile(profile);
      }
      emit(state.copyWith(status: ProfileStatus.success, profile: profile));
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.error, error: e.toString()));
    }
  }
}
