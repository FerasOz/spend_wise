import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class UpdateProfile {
  final ProfileRepository _repository;

  const UpdateProfile(this._repository);

  Future<void> call(Profile profile) => _repository.updateProfile(profile);
}
