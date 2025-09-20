import 'package:equatable/equatable.dart';

class UserAuth extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final bool isEmailVerified;

  const UserAuth({
    required this.id,
    required this.email,
    required this.name,
    this.profileImage,
    required this.createdAt,
    required this.lastLoginAt,
    this.isEmailVerified = false,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        profileImage,
        createdAt,
        lastLoginAt,
        isEmailVerified,
      ];

  UserAuth copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImage,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isEmailVerified,
  }) {
    return UserAuth(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }
}
