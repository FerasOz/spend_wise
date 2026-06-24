import 'package:get_it/get_it.dart';
import 'package:spend_wise/features/auth/data/repositories/supabase_auth_repository.dart';
import 'package:spend_wise/features/auth/domain/repositories/auth_repository.dart';
import 'package:spend_wise/features/auth/domain/usecases/login.dart';
import 'package:spend_wise/features/auth/domain/usecases/logout.dart';
import 'package:spend_wise/features/auth/domain/usecases/register.dart';
import 'package:spend_wise/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> registerAuthFeature(GetIt sl) async {
  // External dependencies
  if (!sl.isRegistered<SupabaseClient>()) {
    sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
  }

  // Data sources (if any) - currently using Supabase client directly in repository
  // If we had separate data sources, we would register them here

  // Repository
  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(
      () => SupabaseAuthRepository(sl<SupabaseClient>()),
    );
  }

  // Use cases
  if (!sl.isRegistered<LoginUseCase>()) {
    sl.registerFactory<LoginUseCase>(() => LoginUseCase(sl<AuthRepository>()));
  }
  if (!sl.isRegistered<LogoutUseCase>()) {
    sl.registerFactory<LogoutUseCase>(() => LogoutUseCase(sl<AuthRepository>()));
  }
  if (!sl.isRegistered<RegisterUseCase>()) {
    sl.registerFactory<RegisterUseCase>(() => RegisterUseCase(sl<AuthRepository>()));
  }

  // Cubit/Bloc
  if (!sl.isRegistered<AuthCubit>()) {
    sl.registerFactory<AuthCubit>(
      () => AuthCubit(
        loginUseCase: sl<LoginUseCase>(),
        logoutUseCase: sl<LogoutUseCase>(),
        registerUseCase: sl<RegisterUseCase>(),
      ),
    );
  }
}