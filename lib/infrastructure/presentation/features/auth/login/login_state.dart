import 'package:flutter/material.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_user.dart';
import 'package:trip_planner/infrastructure/infrastructure.dart';
import 'package:trip_planner/shared/errors/error_auth.dart';

/// State for the login feature.
class LoginState with ChangeNotifier {
  /// Controller for the email entered in the login form.
  final TextEditingController controllerEmail = TextEditingController();

  /// Controller for the password entered in the login form.
  final TextEditingController controllerPassword = TextEditingController();

  var _loading = false;
  var _disposed = false;

  /// Whether a login attempt is in progress.
  bool get loading => _loading;

  /// Attempts to log in and returns the authentication module's result.
  Future<Result<AppUser, AuthError>> attemptLogin() async {
    _loading = true;
    notifyListeners();

    try {
      final credentials = UserCredentials(
        email: controllerEmail.text,
        password: controllerPassword.text,
      );

      return await authUseCase.attemptLogin(credentials);
    } finally {
      _loading = false;

      if (!_disposed) {
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }
}
