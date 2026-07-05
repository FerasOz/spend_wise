import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class GetProfile {
  final ProfileRepository _repository;

  const GetProfile(this._repository);

  Future<Profile?> call(String userId) => _repository.getProfile(userId);
}
