import 'dart:convert';

import 'package:trip_planner/entities/entity_user.dart';
import 'package:trip_planner/shared/errors/error_auth.dart';

/// Authentication business rules that do not require storage or database access.
abstract final class AuthRules {
  /// Validates the fields required to attempt a login.
  static AuthError? validateLogin(UserCredentials credentials) {
    final emailError = validateEmail(credentials.email);
    if (emailError != null) {
      return emailError;
    }

    return validatePassword(credentials.password, isRegistration: false);
  }

  /// Validates the fields required to register an account.
  static AuthError? validateRegister(UserCredentials credentials) {
    final nameError = validateName(credentials.name);
    if (nameError != null) {
      return nameError;
    }

    final emailError = validateEmail(credentials.email);
    if (emailError != null) {
      return emailError;
    }

    return validatePassword(credentials.password);
  }

  /// Requires a nonblank registration name without restricting personal names.
  static AuthError? validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return AuthError.nameRequired;
    }

    return null;
  }

  /// Requires an email with a local part and a dotted domain, without whitespace.
  static AuthError? validateEmail(String email) {
    if (email.trim().isEmpty) {
      return AuthError.emailRequired;
    }

    if (!RegExp(r'^[^\s@]+@[^\s@.]+(?:\.[^\s@.]+)+$').hasMatch(email)) {
      return AuthError.invalidEmail;
    }

    return null;
  }

  /// Requires a password within bcrypt's byte limit and eight characters at registration.
  static AuthError? validatePassword(
    String password, {
    bool isRegistration = true,
  }) {
    if (password.isEmpty) {
      return AuthError.passwordRequired;
    }

    if (isRegistration && password.runes.length < 8) {
      return AuthError.passwordTooShort;
    }

    if (utf8.encode(password).length > 72) {
      return AuthError.passwordTooLong;
    }

    return null;
  }
}
