import 'package:flutter/cupertino.dart';

/// Represents the credentials of an user.
@immutable
final class UserCredentials {
  /// Default constructor.
  const UserCredentials({
    this.name,
    required this.email,
    required this.password,
  });

  /// Represents the user's name when registering.
  final String? name;

  /// Represents the user's email.
  final String email;

  /// Represents the user's password.
  final String password;

  /// Returns an JSON based on the given [UserCredentials].
  Map<String, dynamic> toJSON() {
    return {'name': name, 'email': email, 'password': password};
  }

  /// Returns a copy with the given fields replaced.
  UserCredentials copyWith({String? name, String? email, String? password}) {
    return UserCredentials(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}

/// Represents the application user.
@immutable
final class User {
  /// Default constructor.
  const User({required this.id, required this.name, required this.email});

  /// Database identifier of the user.
  final int id;

  /// Display name of the user.
  final String name;

  /// Email address of the user.
  final String email;

  factory User.fromJSON(Map<String, dynamic> json) {
    return User(id: json['id'], name: json['name'], email: json['email']);
  }

  /// Returns user information suitable for session storage.
  Map<String, dynamic> toJSON() {
    return {'id': id, 'name': name, 'email': email};
  }
}
