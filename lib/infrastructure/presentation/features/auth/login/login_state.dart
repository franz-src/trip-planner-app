import 'package:flutter/material.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_user.dart';
import 'package:trip_planner/infrastructure/infrastructure.dart';
import 'package:trip_planner/shared/errors/error_auth.dart';
import 'package:trip_planner/infrastructure/presentation/app_state.dart';

/// State for the login feature.
class LoginState with ChangeNotifier {
  /// Default constructor.
  LoginState(this._appState);

  final AppState _appState;
  AuthError? _error;

  /// Controller for the email entered in the login form.
  final TextEditingController controllerEmail = TextEditingController();

  /// Controller for the password entered in the login form.
  final TextEditingController controllerPassword = TextEditingController();

  var _loading = false;
  var _disposed = false;

  /// Whether a login attempt is in progress.
  bool get loading => _loading;

  /// The latest authentication failure.
  AuthError? get error => _error;

  /// Attempts to log in and returns the authentication module's result.
  Future<Result<User, AuthError>> attemptLogin() async {
    if (_loading) {
      return Result.failure(AuthError.unexpected);
    }

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final credentials = UserCredentials(
        email: controllerEmail.text,
        password: controllerPassword.text,
      );

      final result = await authUseCase.attemptLogin(credentials);
      switch (result) {
        case Success(:final value):
          _appState.acceptUser(value);
        case Failure(:final error):
          _error = error;
      }

      return result;
    } catch (e) {
      _error = AuthError.unexpected;

      return Result.failure(AuthError.unexpected);
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
