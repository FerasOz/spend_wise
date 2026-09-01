import 'package:spend_wise/features/auth/domain/entities/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends AppUser {
  UserModel({
    required super.uid,
    required super.email,
    required super.displayName,
    super.requiresEmailConfirmation,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromEntity(AppUser user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
    );
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  AppUser toEntity() {
    return AppUser(uid: uid, email: email, displayName: displayName);
  }
}
