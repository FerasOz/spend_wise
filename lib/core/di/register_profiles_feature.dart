import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/profiles/data/datasources/profile_remote_data_source.dart';
import '../../features/profiles/data/repositories/profile_repository_impl.dart';
import '../../features/profiles/domain/repositories/profile_repository.dart';
import '../../features/profiles/domain/usecases/create_profile.dart';
import '../../features/profiles/domain/usecases/get_profile.dart';
import '../../features/profiles/domain/usecases/update_profile.dart';
import '../../features/profiles/presentation/cubit/profile_cubit.dart';

Future<void> registerProfilesFeature(GetIt sl) async {
  if (!sl.isRegistered<ProfileRemoteDataSource>()) {
    sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => SupabaseProfileRemoteDataSource(sl<SupabaseClient>()),
    );
  }

  if (!sl.isRegistered<ProfileRepository>()) {
    sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(sl<ProfileRemoteDataSource>()),
    );
  }

  if (!sl.isRegistered<GetProfile>()) {
    sl.registerLazySingleton<GetProfile>(
      () => GetProfile(sl<ProfileRepository>()),
    );
  }

  if (!sl.isRegistered<CreateProfile>()) {
    sl.registerLazySingleton<CreateProfile>(
      () => CreateProfile(sl<ProfileRepository>()),
    );
  }

  if (!sl.isRegistered<UpdateProfile>()) {
    sl.registerLazySingleton<UpdateProfile>(
      () => UpdateProfile(sl<ProfileRepository>()),
    );
  }

  if (!sl.isRegistered<ProfileCubit>()) {
    sl.registerFactory<ProfileCubit>(
      () => ProfileCubit(
        getProfile: sl<GetProfile>(),
        createProfile: sl<CreateProfile>(),
        updateProfile: sl<UpdateProfile>(),
      ),
    );
  }
}
