import 'package:flutter/material.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_user.dart';
import 'package:trip_planner/infrastructure/infrastructure.dart';
import 'package:trip_planner/shared/errors/error_auth.dart';

/// State for the registration feature.
class RegisterState with ChangeNotifier {
  /// Controller for the name entered in the registration form.
  final TextEditingController controllerName = TextEditingController();

  /// Controller for the email entered in the registration form.
  final TextEditingController controllerEmail = TextEditingController();

  /// Controller for the password entered in the registration form.
  final TextEditingController controllerPassword = TextEditingController();

  var _loading = false;
  var _disposed = false;

  /// Whether a registration attempt is in progress.
  bool get loading => _loading;

  /// Attempts to register and returns the authentication module's result.
  Future<Result<void, AuthError>> attemptRegister() async {
    _loading = true;
    notifyListeners();

    try {
      final credentials = UserCredentials(
        name: controllerName.text,
        email: controllerEmail.text,
        password: controllerPassword.text,
      );

      return await authUseCase.attemptRegister(credentials);
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
    controllerName.dispose();
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }
}
