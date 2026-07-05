import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<Profile?> getProfile(String userId);

  Future<void> createProfile(Profile profile);

  Future<void> updateProfile(Profile profile);
}
