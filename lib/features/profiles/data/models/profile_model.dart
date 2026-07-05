import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/profile.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  final String id;

  @JsonKey(name: 'display_name')
  final String? displayName;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  const ProfileModel({
    required this.id,
    this.displayName,
    required this.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  factory ProfileModel.fromEntity(Profile profile) {
    return ProfileModel(
      id: profile.id,
      displayName: profile.displayName,
      createdAt: profile.createdAt,
    );
  }

  Profile toEntity() {
    return Profile(id: id, displayName: displayName, createdAt: createdAt);
  }
}
