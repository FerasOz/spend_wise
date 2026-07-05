import 'package:equatable/equatable.dart';
import '../../domain/entities/profile.dart';

class ProfileState extends Equatable {
  final ProfileStatus status;
  final Profile? profile;
  final String? error;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.error,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    Profile? profile,
    String? error,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, profile, error];
}

enum ProfileStatus { initial, loading, success, error }
