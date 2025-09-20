import '../../domain/entities/user_auth.dart';

class UserAuthModel extends UserAuth {
  const UserAuthModel({
    required super.id,
    required super.email,
    required super.name,
    super.profileImage,
    required super.createdAt,
    required super.lastLoginAt,
    super.isEmailVerified = false,
  });

  factory UserAuthModel.fromJson(Map<String, dynamic> json) {
    return UserAuthModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      profileImage: json['profile_image'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastLoginAt: DateTime.parse(json['last_login_at'] as String),
      isEmailVerified: json['is_email_verified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profile_image': profileImage,
      'created_at': createdAt.toIso8601String(),
      'last_login_at': lastLoginAt.toIso8601String(),
      'is_email_verified': isEmailVerified,
    };
  }

  factory UserAuthModel.fromEntity(UserAuth user) {
    return UserAuthModel(
      id: user.id,
      email: user.email,
      name: user.name,
      profileImage: user.profileImage,
      createdAt: user.createdAt,
      lastLoginAt: user.lastLoginAt,
      isEmailVerified: user.isEmailVerified,
    );
  }
}
