import 'package:flutter/foundation.dart';

class UserModel {
  final String id;
  final String? email;
  final String username;
  final bool isGuest;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  UserModel({
    required this.id,
    this.email,
    required this.username,
    required this.isGuest,
    required this.createdAt,
    this.lastLoginAt,
  });

  String get displayName => isGuest ? 'ضيف' : username;

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String?,
      username: map['username'] as String,
      isGuest: (map['email'] == null || map['email']!.isEmpty),
      createdAt: DateTime.parse(map['created_at'] as String),
      lastLoginAt: map['last_login_at'] != null
          ? DateTime.parse(map['last_login_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'created_at': createdAt.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    ValueGetter<String?>? email,
    String? username,
    bool? isGuest,
    DateTime? createdAt,
    ValueGetter<DateTime?>? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email != null ? email() : this.email,
      username: username ?? this.username,
      isGuest: isGuest ?? this.isGuest,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt != null ? lastLoginAt() : this.lastLoginAt,
    );
  }
}
