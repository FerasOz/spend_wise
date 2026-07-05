import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class CreateProfile {
  final ProfileRepository _repository;

  const CreateProfile(this._repository);

  Future<void> call(Profile profile) => _repository.createProfile(profile);
}
