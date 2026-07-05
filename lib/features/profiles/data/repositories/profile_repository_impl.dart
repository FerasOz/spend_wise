import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<void> createProfile(Profile profile) async {
    final model = ProfileModel.fromEntity(profile);
    await _remoteDataSource.upsertProfile(model);
  }

  @override
  Future<Profile?> getProfile(String userId) async {
    final profileModel = await _remoteDataSource.getProfile(userId);
    return profileModel?.toEntity();
  }

  @override
  Future<void> updateProfile(Profile profile) async {
    final model = ProfileModel.fromEntity(profile);
    await _remoteDataSource.upsertProfile(model);
  }
}
